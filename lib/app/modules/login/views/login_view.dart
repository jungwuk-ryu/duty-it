import 'package:duty_it/app/modules/login/widgets/login_button.dart';
import 'package:duty_it/app/modules/splash/views/splash_view.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginView extends GetView<LoginViewController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SimpleAppBar(title: '로그인'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50, left: 16, right: 16),
                child: Column(
                  children: [
                    Spacer(),
                    Hero(
                      tag: SplashView.heroKey,
                      child: Image.asset(
                        Assets.icons.logo.path,
                        width: 84,
                        height: 80,
                      ),
                    ),
                    Spacer(),
                    Column(
                      spacing: 16,
                      children: [
                        /*LoginButton(
                    iconPath: Assets.icons.kakao.path,
                    providerName: "Kakao",
                    buttonColor: Color(0xFFFEE500),
                    onTap: () async =>
                        controller.onLoginButtonTap(SocialProvider.kakao),
                  ),*/
                        LoginButton(
                          iconPath: Assets.icons.appleWhite.path,
                          buttonColor: Color(0xFF000000),
                          providerName: "Apple",
                          onTap: () async =>
                              controller.onLoginButtonTap(SocialProvider.apple),
                        ),
                        LoginButton(
                          iconPath: Assets.icons.google.path,
                          buttonColor: Color(0xFFF2F2F2),
                          providerName: "Google",
                          onTap: () async => controller.onLoginButtonTap(
                            SocialProvider.google,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
