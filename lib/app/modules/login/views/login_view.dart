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
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SimpleAppBar(title: '로그인'),
              Expanded(
                // 큰 글씨 설정에서도 동의 항목과 로그인 버튼이 화면 밖으로 밀려나지 않도록 스크롤을 허용한다.
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 50,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          // 남는 공간을 제목 위와 아래에 똑같이 나눠 기존 배치를 유지한다.
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox.shrink(),
                            Column(
                              spacing: 10,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.black
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "듀잇",
                                        style: TextStyle(color: AppColors.main),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Hero(
                                          tag: SplashView.heroKey,
                                          child: Image.asset(
                                            Assets.icons.logo.path,
                                            width: 29,
                                            height: 25,
                                          ),
                                        ),
                                      ),
                                      TextSpan(text: "과 함께,\n모든 간호 행사를 한눈에!"),
                                    ],
                                  ),
                                ),
                                Text(
                                  '10초만에 로그인하고 모든 기능을 이용해보세요.',
                                  style: TextStyle(
                                    color: AppColors.g07,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 328),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => _TermsAgreementRow(
                                          checked: controller.termsAgreed,
                                          onToggle: controller.toggleTermsAgreed,
                                          onTermsTap: controller.openTerms,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _PrivacyPolicyNotice(
                                        onTap: controller.openPrivacyPolicy,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Obx(
                                  () => Opacity(
                                    // 약관 동의 전에는 버튼을 흐리게 보여주고, 눌러도 동의 안내만 띄운다.
                                    opacity: controller.termsAgreed ? 1 : 0.45,
                                    child: Column(
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
                                              controller.onLoginButtonTap(
                                                SocialProvider.apple,
                                              ),
                                        ),
                                        LoginButton(
                                          iconPath: Assets.icons.google.path,
                                          buttonColor: Color(0xFFF2F2F2),
                                          providerName: "Google",
                                          onTap: () async =>
                                              controller.onLoginButtonTap(
                                                SocialProvider.google,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsAgreementRow extends StatelessWidget {
  static const _label = '[필수] 만 14세 이상이며, 듀잇 이용약관에 동의합니다';

  final bool checked;
  final VoidCallback onToggle;
  final VoidCallback onTermsTap;

  const _TermsAgreementRow({
    required this.checked,
    required this.onToggle,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.40,
    );

    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (_) => onToggle(),
          semanticLabel: _label,
          activeColor: AppColors.main,
          side: const BorderSide(color: AppColors.g05, width: 1.5),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Text.rich(
              TextSpan(
                style: textStyle,
                children: [
                  const TextSpan(
                    text: '[필수] ',
                    style: TextStyle(color: AppColors.main),
                  ),
                  const TextSpan(text: '만 14세 이상이며, 듀잇 '),
                  _linkSpan('이용약관', onTermsTap, textStyle),
                  const TextSpan(text: '에 동의합니다'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyPolicyNotice extends StatelessWidget {
  final VoidCallback onTap;

  const _PrivacyPolicyNotice({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: AppColors.g07,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.40,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text.rich(
        TextSpan(
          style: textStyle,
          children: [
            const TextSpan(text: '회원 정보 처리에 관한 내용은 '),
            _linkSpan(
              '개인정보 처리방침',
              onTap,
              textStyle.copyWith(fontWeight: FontWeight.w700),
            ),
            const TextSpan(text: '에서 확인할 수 있어요'),
          ],
        ),
      ),
    );
  }
}

WidgetSpan _linkSpan(String text, VoidCallback onTap, TextStyle style) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: Semantics(
      link: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(
          text,
          style: style.copyWith(
            color: AppColors.linkBlue,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.linkBlue,
          ),
        ),
      ),
    ),
  );
}
