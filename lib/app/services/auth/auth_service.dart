import 'dart:async';
import 'dart:developer';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/apple_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/google_login_strategy.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:duty_it/app/services/push_token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum SocialProvider {
  kakao('카카오'),
  google('Google'),
  apple('Apple');

  final String displayName;

  const SocialProvider(this.displayName);

  static SocialProvider? getByName(String name) {
    for (var provider in SocialProvider.values) {
      if (provider.name == name) return provider;
    }

    return null;
  }
}

class AuthService extends GetxService {
  static const String storageBoxName = "authService";
  static const String _appUserKey = 'app_user';
  static const String _lastUsedProviderKey = 'last_used_provider';

  AuthService({
    this._currentUserLoader,
    this._firebaseAuth,
    GetStorage Function(String boxName)? storageFactory,
    Future<void> Function(String? userId)? analyticsUserIdSetter,
  }) : _storageFactory = storageFactory ?? GetStorage.new,
       _analyticsUserIdSetter = analyticsUserIdSetter ?? _setAnalyticsUserId;

  final Map<SocialProvider, SocialLoginStrategy> _strategies = {};
  final Rxn<AppUser> _appUser = Rxn();
  late final GetStorage _box;
  Future<AppUser?>? _appUserLoadFuture;
  final Future<RequestResult<AppUser>> Function()? _currentUserLoader;
  final FirebaseAuth? _firebaseAuth;
  FirebaseAuth get _auth => _firebaseAuth ?? FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  String? _profileUid;
  final GetStorage Function(String boxName) _storageFactory;
  final Future<void> Function(String? userId) _analyticsUserIdSetter;
  Future<void> _analyticsUpdate = Future.value();
  String? _analyticsUserId;
  bool _analyticsIdentityInitialized = false;
  int _userRevision = 0;

  AppUser? get appUser {
    final profile = _appUser.value;
    return profile != null && !isClosed && _profileUid == _auth.currentUser?.uid
        ? profile
        : null;
  }

  set appUser(AppUser? user) {
    if (isClosed) return;
    final uid = _auth.currentUser?.uid;
    _selectProfile(uid);
    _userRevision++;
    _appUser.value = uid == null ? null : user;

    if (user != null && uid != null) {
      _box.write(_appUserKey, {'uid': uid, 'profile': user.toJson()});
    } else {
      _box.remove(_appUserKey);
    }
    unawaited(syncAnalyticsUserId());
  }

  static Future<void> _setAnalyticsUserId(String? userId) {
    return FirebaseAnalytics.instance.setUserId(id: userId);
  }

  Future<void> syncAnalyticsUserId() {
    // Match the web's backend member ID, rather than email or Firebase UID.
    final uid = _auth.currentUser?.uid;
    final userId = appUser?.id.toString();
    if (_analyticsIdentityInitialized && userId == _analyticsUserId) {
      return _analyticsUpdate;
    }
    _analyticsIdentityInitialized = true;
    _analyticsUserId = userId;
    // Serialize native SDK calls so a slow previous account cannot win later.
    _analyticsUpdate = _analyticsUpdate.then((_) async {
      if (isClosed || (userId != null && _auth.currentUser?.uid != uid)) return;
      try {
        await _analyticsUserIdSetter(userId);
      } catch (e, st) {
        if (_analyticsUserId == userId) _analyticsIdentityInitialized = false;
        log('Failed to update Analytics user ID', error: e, stackTrace: st);
      }
    });
    return _analyticsUpdate;
  }

  SocialLoginStrategy? _currentStrategy;

  @override
  void onInit() {
    super.onInit();
    _initStrategies();

    _box = _storageFactory(storageBoxName);
    _profileUid = _auth.currentUser?.uid;
    _loadCachedAppUser(_profileUid);
    unawaited(syncAnalyticsUserId());
    _authSubscription = _auth.authStateChanges().listen((user) {
      // A delayed signal must not select a user who has already signed out.
      if (user?.uid == _auth.currentUser?.uid) _selectProfile(user?.uid);
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  void _selectProfile(String? uid) {
    if (_profileUid == uid) return;
    _profileUid = uid;
    _userRevision++;
    _appUserLoadFuture = null;
    _appUser.value = null;
    if (uid == null) {
      _box.remove(_appUserKey);
    } else {
      _loadCachedAppUser(uid);
    }
    unawaited(syncAnalyticsUserId());
  }

  void _loadCachedAppUser(String? uid) {
    final cached = _box.read(_appUserKey);
    if (cached == null) return;
    if (cached is! Map ||
        cached['uid'] is! String ||
        cached['profile'] is! Map<String, dynamic>) {
      // Older versions stored a bare profile whose owner cannot be verified.
      _box.remove(_appUserKey);
      return;
    }
    if (uid == null) return;
    if (cached['uid'] != uid) {
      _box.remove(_appUserKey);
      return;
    }

    try {
      _appUser.value = AppUser.fromJson(cached['profile']);
    } catch (e, st) {
      if (kDebugMode) {
        log('Failed to load app user!', error: e, stackTrace: st);
      }
    }
  }

  void _initStrategies() {
    _strategies[SocialProvider.google] = GoogleLoginStrategy();
    _strategies[SocialProvider.apple] = AppleLoginStrategy();
  }

  SocialProvider getLastUsedProvider() {
    SocialProvider? prov;
    try {
      prov = SocialProvider.getByName(_box.read(_lastUsedProviderKey));
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }

    prov ??= SocialProvider.google;
    return prov;
  }

  Future<SocialLoginResult> socialLogin(SocialProvider provider) async {
    await logout();

    SocialLoginStrategy? strategy = _strategies[provider];
    if (strategy == null) {
      return SocialLoginFail(reason: "지원하지 않는 소셜 로그인입니다.");
    }

    var result = await strategy.login();
    if (result is SocialLoginSuccess) _currentStrategy = strategy;
    _box.write(_lastUsedProviderKey, provider.name);

    return result;
  }

  Future<void> logout() async {
    await _unregisterDeviceSafely();
    if (Get.isRegistered<ApiClient>()) {
      Get.find<ApiClient>().invalidateSession();
    }

    // Firebase
    try {
      await _auth.signOut();
      await _awaitFirebaseLogout();
    } catch (_) {
      _resumePushSync();
      rethrow;
    }

    // Social
    try {
      await _currentStrategy?.logout();
    } finally {
      await _doPostLogoutJob();
    }
  }

  Future<bool> withdraw() async {
    if (appUser == null) {
      AppUtils.showSnackBar('회원탈퇴 중 알 수 없는 오류가 발생했어요.');
      return false;
    }

    final api = Get.find<ApiClient>();
    await _unregisterDeviceSafely();
    final RequestResult<void> reqResult;
    try {
      reqResult = await api.withdrawUser();
    } catch (_) {
      _resumePushSync();
      rethrow;
    }
    if (reqResult is RequestFail) {
      _resumePushSync();
      AppUtils.showSnackBar('회원탈퇴 중 오류가 발생했어요.');
      if (reqResult.serverFail != null) {
        AppUtils.showSnackBar(reqResult.serverFail!.message);
      }
      return false;
    }

    api.invalidateSession();
    await _deleteFirebaseUserSafely();

    // Social
    try {
      await _currentStrategy?.logout();
    } finally {
      await _doPostLogoutJob();
    }

    return true;
  }

  Future<AppUser?> ensureAppUserLoaded() {
    final uid = _auth.currentUser?.uid;
    _selectProfile(uid);
    AppUser? profileForCaller() =>
        _auth.currentUser?.uid == uid ? appUser : null;
    if (uid == null || appUser != null) {
      return syncAnalyticsUserId().then((_) => profileForCaller());
    }
    if (_appUserLoadFuture != null) return _appUserLoadFuture!;

    final revision = _userRevision;
    late final Future<AppUser?> future;
    future =
        (() async {
          try {
            final result = await _loadCurrentUser();
            if (isClosed) return null;
            _selectProfile(_auth.currentUser?.uid);
            if (_profileUid == uid &&
                revision == _userRevision &&
                result is RequestSuccess<AppUser>) {
              appUser = result.data;
            }
            await syncAnalyticsUserId();
          } catch (e, st) {
            FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
          }
          return profileForCaller();
        })().whenComplete(() {
          if (identical(_appUserLoadFuture, future)) _appUserLoadFuture = null;
        });

    _appUserLoadFuture = future;
    return future;
  }

  Future<void> _doPostLogoutJob() async {
    appUser = null;
    _currentStrategy = null;
    _appUserLoadFuture = null;
    await syncAnalyticsUserId();

    if (Get.isRegistered<CalendarViewController>()) {
      await Get.find<CalendarViewController>().clearCache().catchError((e, st) {
        FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      });
    }
  }

  void _resumePushSync() {
    if (Get.isRegistered<PushTokenService>()) {
      Get.find<PushTokenService>().resumeAfterFailedLogout();
    }
  }

  Future<void> _unregisterDeviceSafely() async {
    if (!isLoggined() || !Get.isRegistered<PushTokenService>()) return;

    try {
      if (!await Get.find<PushTokenService>().unregisterForLogout()) {
        FirebaseCrashlytics.instance.recordError(
          'Failed to unregister device token',
          null,
          fatal: false,
          reason: '디바이스 토큰 삭제 실패',
        );
      }
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }
  }

  Future<void> _awaitFirebaseLogout() async {
    await _auth.authStateChanges().firstWhere((u) => u == null);
  }

  Future<void> _deleteFirebaseUserSafely() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      await _safeFirebaseSignOut();
      return;
    }

    try {
      await currentUser.delete();
      await _awaitFirebaseLogout();
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      await _safeFirebaseSignOut();
    }
  }

  Future<void> _safeFirebaseSignOut() async {
    try {
      await _auth.signOut();
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }
  }

  bool isLoggined() => _auth.currentUser != null;

  Future<RequestResult<AppUser>> _loadCurrentUser() {
    if (_currentUserLoader != null) return _currentUserLoader();
    return Get.find<ApiClient>().getCurrentUser();
  }
}
