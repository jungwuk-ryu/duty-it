import 'package:cloud_functions/cloud_functions.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' hide User;

class KakaoLoginStrategy extends SocialLoginStrategy {
  @override
  Future<SocialLoginResult> login() async {
    try {
      final installed = await isKakaoTalkInstalled();
      final OAuthToken authToken = await (installed
          ? UserApi.instance.loginWithKakaoTalk()
          : UserApi.instance.loginWithKakaoAccount());

      final callable = FirebaseFunctions.instance.httpsCallable('kakaoSignIn');
      final rp = await callable.call(<String, dynamic>{
        'accessToken': authToken.accessToken,
      });
      final data = rp.data as Map;
      final customToken = data['customToken'] as String?;

      if (customToken == null) {
        return SocialLoginFail(reason: kDebugMode ? "customToken이 null임" : '로그인 실패 : 인증 정보가 없습니다.');
      }

      final credential = await FirebaseAuth.instance.signInWithCustomToken(customToken);
      final user = credential.user;
      if (user == null) {
        return SocialLoginFail(reason: '로그인 실패 : 사용자 정보가 없습니다.');
      }

      try {
        await linkKakaoOidcWithTokens(user, authToken);
      } on FirebaseAuthException catch (_) {
        if (kIsWeb) {
          await linkKakaoOidcViaPopup(user);
        } else {
          await linkKakaoOidcViaRedirect(user);
        }
      }

      return SocialLoginSuccess();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
      if (kDebugMode) AppUtils.showSnackBar("$e");
      return SocialLoginFail(reason: kDebugMode ? e.toString() : '로그인 실패');
    }
  }

  Future<void> linkKakaoOidcWithTokens(User user, OAuthToken kakaoToken) async {
  final provider = OAuthProvider('oidc.kakao_rest');

  final hasIdToken = (kakaoToken.idToken?.isNotEmpty ?? false);

  final credential = provider.credential(
    accessToken: kakaoToken.accessToken,
    idToken: hasIdToken ? kakaoToken.idToken : null,
  );

  final alreadyLinked = user.providerData.any((p) => p.providerId == 'oidc.kakao_rest');
  if (alreadyLinked) return;

  try {
    await user.linkWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'provider-already-linked') return;
    if (e.code == 'credential-already-in-use') {
      rethrow;
    }
    if (e.code == 'requires-recent-login') {
      await user.reauthenticateWithCredential(credential);
      await user.linkWithCredential(credential);
    } else {
      rethrow;
    }
  }
}

Future<void> linkKakaoOidcViaPopup(User user) async {
  final provider = OAuthProvider('oidc.kakao_rest');
  if (!kIsWeb) throw UnsupportedError('Web only');

  try {
    await user.linkWithPopup(provider);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'popup-closed-by-user') return;
    if (e.code == 'provider-already-linked') return;
    rethrow;
  }
}

Future<void> linkKakaoOidcViaRedirect(User user) async {
  final provider = OAuthProvider('oidc.kakao_rest');
  provider.setCustomParameters({
    'prompt': 'consent',
  });
  provider.addScope('profile_nickname');
  provider.addScope('account_email');

  await user.linkWithProvider(provider);
}

  @override
  Future<void> logout() async {
    await UserApi.instance.logout();
  }
}
