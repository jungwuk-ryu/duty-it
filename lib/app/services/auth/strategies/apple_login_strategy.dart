import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
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

      await FirebaseAuth.instance.signInWithProvider(appleProvider);
      return SocialLoginSuccess();
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
      if (kDebugMode) AppUtils.showSnackBar("$e");
      if (kDebugMode) AppUtils.showSnackBar("$st");
      return SocialLoginFail(reason: kDebugMode ? "$e\n$st" : '로그인 실패');
    }
  }

  @override
  Future<void> logout() async {}
}
