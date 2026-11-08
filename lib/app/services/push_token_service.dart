import 'dart:async';
import 'dart:developer' as developer;

import 'package:duty_it/app/api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

class PushTokenService extends GetxService with WidgetsBindingObserver {
  PushTokenService({
    required this.currentUid,
    required this.authChanges,
    required this.tokenChanges,
    required this.loadToken,
    required this.register,
    required this.unregister,
    required this.deleteToken,
  });

  factory PushTokenService.firebase(ApiClient api) {
    final auth = FirebaseAuth.instance;
    final messaging = FirebaseMessaging.instance;
    return PushTokenService(
      currentUid: () => auth.currentUser?.uid,
      authChanges: auth.authStateChanges().map((user) => user?.uid),
      tokenChanges: messaging.onTokenRefresh,
      loadToken: () async {
        await _nativeDeletion;
        final usesApns =
            !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS);
        if (usesApns && await messaging.getAPNSToken() == null) return null;
        return messaging.getToken();
      },
      register: (token) async =>
          _nativeDeletion == null &&
          await api.registerDevice(token) is RequestSuccess,
      unregister: (token) async =>
          await api.unregisterDevice(token) is RequestSuccess,
      deleteToken: () =>
          _nativeDeletion ??= messaging.deleteToken().whenComplete(() {
            _nativeDeletion = null;
          }),
    );
  }

  // The FCM installation outlives GetX services recreated during login.
  static Future<void>? _nativeDeletion;
  final String? Function() currentUid;
  final Stream<String?> authChanges;
  final Stream<String> tokenChanges;
  final Future<String?> Function() loadToken;
  final Future<bool> Function(String token) register;
  final Future<bool> Function(String token) unregister;
  final Future<void> Function() deleteToken;

  final _writes = Lock();
  StreamSubscription<String?>? _authSubscription;
  StreamSubscription<String>? _tokenSubscription;
  Timer? _retry;
  int _retrySeconds = 1;
  int _revision = 0;
  String? _uid;
  String? _loggingOut;
  String? _attemptedToken;
  String? _registeredToken;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _authSubscription = authChanges.distinct().listen(_changeAccount);
    _tokenSubscription = tokenChanges.listen(
      (token) => _sync(token: token),
      onError: (Object _) => _sync(),
    );
    _changeAccount(currentUid());
  }

  void _changeAccount(String? uid) {
    if (uid != currentUid()) return;
    if (uid != _loggingOut) _loggingOut = null;
    if (_uid == uid) return;
    _invalidate();
    _registeredToken = null;
    _attemptedToken = null;
    _uid = uid;
    _sync();
  }

  void _invalidate() {
    _revision++;
    _retry?.cancel();
    _retrySeconds = 1;
  }

  bool _active(int revision) =>
      _revision == revision &&
      _uid != null &&
      _uid == currentUid() &&
      _uid != _loggingOut;

  Future<void> _sync({String? token}) async {
    if (!_active(_revision)) return;
    final revision = ++_revision;
    final uid = _uid;
    _retry?.cancel();
    try {
      token ??= await loadToken().timeout(const Duration(seconds: 15));
      if (!_active(revision)) return;
      if (token != null && token.isNotEmpty) {
        final candidate = token;
        final done = await _writes.synchronized(() async {
          if (!_active(revision) || candidate == _registeredToken) return true;
          _attemptedToken = candidate;
          if (!await register(candidate)) return false;
          // A refresh can supersede this write without changing its owner.
          if (_uid == uid && currentUid() == uid) _registeredToken = candidate;
          return true;
        });
        if (done) {
          if (_active(revision)) _retrySeconds = 1;
          return;
        }
      }
    } catch (_) {
      // A native token and the registration API can both be unavailable at launch.
    }

    if (!_active(revision)) return;
    _retry = Timer(Duration(seconds: _retrySeconds), _sync);
    _retrySeconds = (_retrySeconds * 2).clamp(1, 300);
  }

  // Stop scheduling PATCH requests before sign-out, then let a PATCH already
  // on the wire finish before issuing the corresponding DELETE.
  Future<bool> unregisterForLogout() async {
    final uid = currentUid();
    if (uid == null) return true;
    _loggingOut = uid;
    _invalidate();
    var expired = false;
    bool canRemove() => !expired && currentUid() == uid && _loggingOut == uid;
    try {
      final removed = await _writes
          .synchronized(() async {
            if (!canRemove()) return false;
            final tokens = <String>{?_registeredToken, ?_attemptedToken};
            if (tokens.isEmpty) {
              final existing = await loadToken().timeout(
                const Duration(seconds: 3),
              );
              if (existing == null || existing.isEmpty) return false;
              tokens.add(existing);
            }
            for (final token in tokens) {
              if (!canRemove() || !await unregister(token)) return false;
            }
            return true;
          })
          .timeout(const Duration(seconds: 3));
      if (removed) return true;
    } catch (_) {
      // An unreachable backend must not trap the user in a signed-in session.
    } finally {
      expired = true;
    }
    // An in-flight PATCH may still reach the previous account. Retire the FCM
    // token when server-side removal cannot be confirmed within the budget.
    if (currentUid() == uid) {
      unawaited(
        deleteToken().catchError((Object _) {
          developer.log('Failed to retire the push token after logout');
        }),
      );
    }
    return false;
  }

  void resumeAfterFailedLogout() {
    _registeredToken = null;
    _loggingOut = null;
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  @override
  void onClose() {
    _invalidate();
    _uid = null;
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    _tokenSubscription?.cancel();
    super.onClose();
  }
}
