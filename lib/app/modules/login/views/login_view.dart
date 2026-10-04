import 'package:duty_it/app/core/constants/app_colors.dart';
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
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: '로그인'),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 64),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Hero(
                                tag: SplashView.heroKey,
                                child: Image.asset(
                                  Assets.icons.logo.path,
                                  width: 36,
                                  height: 36,
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                '듀잇에 로그인하세요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 9),
                              const Text(
                                '관심 있는 간호 행사와 채용 소식을 놓치지 마세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.g05,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 34),
                              LoginButton(
                                iconPath: Assets.icons.google.path,
                                buttonColor: AppColors.white,
                                providerName: 'Google',
                                onTap: () => controller.onLoginButtonTap(
                                  SocialProvider.google,
                                ),
                              ),
                              const SizedBox(height: 12),
                              LoginButton(
                                iconPath: Assets.icons.appleWhite.path,
                                buttonColor: Colors.black,
                                providerName: 'Apple',
                                onTap: () => controller.onLoginButtonTap(
                                  SocialProvider.apple,
                                ),
                              ),
                              const SizedBox(height: 38),
                              const Text(
                                '계속하면 듀잇의 이용약관 및 개인정보 처리방침에 동의하게 됩니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.g05,
                                  fontSize: 11,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
