import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginStrategy extends SocialLoginStrategy {
  bool _isInitialized = false;

  @override
  Future<SocialLoginResult> login() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(provider);
        return SocialLoginSuccess();
      }

      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await _ensureInitialized();

      final GoogleSignInAccount googleUser = await _authenticateWithRetry(
        googleSignIn,
      );
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        FirebaseCrashlytics.instance.recordError(
          StateError('Google login succeeded without idToken'),
          StackTrace.current,
          fatal: false,
        );
        return SocialLoginFail(reason: '로그인 실패');
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      return SocialLoginSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user') {
        // 웹 사용자 취소
        FirebaseAnalytics.instance.logEvent(
          name: 'login_cancelled',
          parameters: {'provider': 'google'},
        );
        return SocialLoginFail(reason: '로그인 취소됨');
      }
      rethrow;
    } on GoogleSignInException catch (e, st) {
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        fatal: false,
        information: [
          'google_sign_in_code: ${e.code.name}',
          'google_sign_in_description: ${e.description ?? 'null'}',
        ],
      );

      if (e.code == GoogleSignInExceptionCode.canceled) {
        // 모바일 사용자 취소
        FirebaseAnalytics.instance.logEvent(
          name: 'login_cancelled',
          parameters: {'provider': 'google'},
        );
        return SocialLoginFail(reason: '로그인 취소됨');
      }

      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      return SocialLoginFail(reason: '로그인 실패');
    } catch (e, st) {
      if (kDebugMode) {
        AppUtils.showSnackBar("$e");
        AppUtils.showSnackBar("$st");
      } else {
        FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      }

      return SocialLoginFail(reason: '로그인 실패');
    }
  }

  @override
  Future<void> logout() async {
    GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await _ensureInitialized();
    await googleSignIn.signOut();
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    await GoogleSignIn.instance.initialize();
    _isInitialized = true;
  }

  Future<GoogleSignInAccount> _authenticateWithRetry(
    GoogleSignIn googleSignIn,
  ) async {
    try {
      return await googleSignIn.authenticate();
    } on GoogleSignInException catch (e, st) {
      if (!_isCredentialFrameworkError(e)) rethrow;

      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        fatal: false,
        information: ['google_sign_in_retry: credential_framework_error'],
      );

      return await googleSignIn.authenticate();
    }
  }

  bool _isCredentialFrameworkError(GoogleSignInException e) {
    if (e.code != GoogleSignInExceptionCode.canceled &&
        e.code != GoogleSignInExceptionCode.interrupted) {
      return false;
    }

    final String desc = (e.description ?? '').toLowerCase();
    return desc.contains('framework') ||
        desc.contains('credential') ||
        desc.contains('interrupted');
  }
}
