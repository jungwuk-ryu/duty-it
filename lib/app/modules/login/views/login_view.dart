import 'package:duty_it/app/modules/splash/views/splash_view.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
              children: [
                GestureDetector(
                  onTap: () =>
                      controller.onLoginButtonTap(SocialProvider.kakao),
                  child: Image.asset(
                    Assets.icons.kakaoLoginLargeWide.path,
                    fit: BoxFit.contain,
                    width: 328.w,
                    height: 50.h,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      controller.onLoginButtonTap(SocialProvider.google),
                  child: Image.asset(
                    Assets.icons.googleLoginButton.path,
                    fit: BoxFit.contain,
                    width: 328.w,
                    height: 50.h,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      controller.onLoginButtonTap(SocialProvider.apple),
                  child: Image.asset(
                    Assets.icons.appleLoginButton.path,
                    fit: BoxFit.contain,
                    width: 328.w,
                    height: 50.h,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(
              () => Visibility(
                visible: controller.isLogining,
                child: SizedBox(
                  width: 130.w,
                  height: 130.h,
                  child: Lottie.asset(
                    Assets.lottie.loadingDots,
                    fit: BoxFit.fitWidth,
                    repeat: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
