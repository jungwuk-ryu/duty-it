import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';

class KakaoLoginStrategy extends SocialLoginStrategy {
  @override
  Future<SocialLoginResult> login() async {
    try {
      bool installed = await isKakaoTalkInstalled();
      OAuthToken authToken = await (installed
          ? UserApi.instance.loginWithKakaoTalk()
          : UserApi.instance.loginWithKakaoAccount());

      var provider = kIsWeb ? OAuthProvider('oidc.kakao_web') : OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: authToken.idToken,
        accessToken: authToken.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return SocialLoginSuccess();
    } catch (e) {
      return SocialLoginFail(reason: kDebugMode ? e.toString() : '로그인 실패');
    }
  }

  @override
  Future<void> logout() async {
    await UserApi.instance.logout();
  }
}
