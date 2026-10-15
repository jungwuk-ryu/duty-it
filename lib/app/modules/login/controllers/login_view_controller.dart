import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_legal.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/login/models/login_result.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginViewController extends GetxController {
  final RxBool _isLogining = RxBool(false);
  bool get isLogining => _isLogining.value;
  set isLogining(v) => _isLogining.value = v;

  // 간주동의를 막기 위해 사용자가 직접 체크해야만 로그인할 수 있다.
  final RxBool _termsAgreed = RxBool(false);
  bool get termsAgreed => _termsAgreed.value;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void onReady() {
    super.onReady();

    if (Get.find<AuthService>().isLoggined()) Get.offAllNamed(AppPages.INITIAL);

    AssetLottie(Assets.lottie.loadingDots).load();
  }

  void toggleTermsAgreed() => _termsAgreed.toggle();

  void openTerms() => AppUtils.openWebUrl(AppLegal.termsUrl);

  void openPrivacyPolicy() => AppUtils.openWebUrl(AppLegal.privacyPolicyUrl);

  Future<void> onLoginButtonTap(SocialProvider provider) async {
    if (!termsAgreed) {
      AppUtils.showSnackBar('이용약관에 동의하면 로그인할 수 있어요.');
      return;
    }
    if (isLogining) return;
    isLogining = true;

    _analytics.logLogin(loginMethod: provider.displayName);

    try {
      var service = Get.find<AuthService>();
      var result = await service.socialLogin(provider);

      switch (result) {
        case SocialLoginSuccess():
          var apiClient = Get.find<ApiClient>();
          RequestResult<LoginResult> rp = await apiClient
              .loginAndRefreshToken(agreedTermsVersion: AppLegal.termsVersion);

          if (rp is RequestSuccess) {
            AppUtils.resetApp();
            _analytics.logEvent(name: "login_success", parameters: {'provider': provider.displayName});
          } else {
            // 약관 동의가 서버에 기록되지 않은 채 로그인 상태로 남지 않도록 되돌린다.
            await FirebaseAuth.instance.signOut();

            var fail = rp as RequestFail;
            AppUtils.showSnackBar(fail.serverFail?.message ?? "null");
            _analytics.logEvent(name: "login_fail", parameters: {'provider': provider.displayName});
          }
        case SocialLoginFail r:
          AppUtils.showSnackBar(r.reason);
      }
    } catch (e, s) {
      AppUtils.showSnackBar("로그인 중 오류가 발생하였습니다.");
      
      if (kDebugMode) {
        AppUtils.showSnackBar("$e");
        AppUtils.showSnackBar("$s");
      }
      
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        fatal: false,
        information: ['provider: ${provider.name}'],
      );

      _analytics.logEvent(name: "login_error", parameters: {'provider': provider.displayName, 'error': e.toString()});
    } finally {
      isLogining = false;
    }
  }
}
