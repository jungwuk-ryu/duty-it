import 'package:duty_it/app/services/auth/models/social_login_result.dart';
import 'package:duty_it/app/services/auth/strategies/social_login_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginStrategy extends SocialLoginStrategy {
  @override
  Future<SocialLoginResult> login() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn.instance;

      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(provider);
        return SocialLoginSuccess();
      }

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return SocialLoginSuccess();
    } catch (e, st) {
      return SocialLoginFail(reason: kDebugMode ? "$e\n$st" : '로그인 실패');
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn.instance.signOut();
  }
}
