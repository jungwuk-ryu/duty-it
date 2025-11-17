import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AppleLoginStrategy extends SocialLoginStrategy {
  @override
  Future<SocialLoginResult> login() async {
    try {
      final appleProvider = AppleAuthProvider();
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(appleProvider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(appleProvider);
      }

      return SocialLoginSuccess();
    } catch (e, st) {
      if (e is FirebaseAuthException &&
          (e.code == 'popup-closed-by-user' ||
              e.code.toLowerCase().contains('canceled'))) { // 사용자 로그인 취소
        FirebaseAnalytics.instance.logEvent(name: 'login_cancelled', parameters: {'provider': 'apple'});
        return SocialLoginFail(reason: "로그인 취소됨");
      }
      
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
  Future<void> logout() async {}
}
