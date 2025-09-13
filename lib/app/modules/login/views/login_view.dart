import 'package:duty_it/app/modules/login/widgets/login_button.dart';
import 'package:duty_it/app/modules/splash/views/splash_view.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginView extends GetView<LoginViewController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: SplashView.heroKey,
              child: Image.asset(Assets.icons.logo.path, width: 84, height: 80),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 88.h,
            child: Column(
              spacing: 10.h,
              children: [
                LoginButton(
                  iconPath: Assets.icons.kakao.path,
                  providerName: "Kakao",
                  buttonColor: Color(0xFFFEE500),
                  onTap: () async =>
                      controller.onLoginButtonTap(SocialProvider.kakao),
                ),
                LoginButton(
                  iconPath: Assets.icons.apple.path,
                  providerName: "Apple",
                  onTap: () async =>
                      controller.onLoginButtonTap(SocialProvider.apple),
                ),
                LoginButton(
                  iconPath: Assets.icons.google.path,
                  providerName: "Google",
                  onTap: () async =>
                      controller.onLoginButtonTap(SocialProvider.google),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
