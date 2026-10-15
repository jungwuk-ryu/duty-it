import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/constants/app_legal.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/widgets/job_info_registration_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 로그인 여부와 관계없이 보이는 약관·개인정보 처리방침·신고번호 영역
class DrawerLegalSection extends StatelessWidget {
  const DrawerLegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 14,
          children: [
            _LegalLink(
              title: '이용약관',
              onTap: () => _openWebUrl(AppLegal.termsUrl),
            ),
            _LegalLink(
              title: '개인정보 처리방침',
              emphasized: true,
              onTap: () => _openWebUrl(AppLegal.privacyPolicyUrl),
            ),
            _LegalLink(
              title: '권리침해 신고',
              onTap: () => _openWebUrl(AppLegal.reportUrl),
            ),
            _LegalLink(
              title: '오픈소스 라이선스',
              onTap: () {
                Get.find<MainViewController>().closeEndDrawer();
                Get.to(LicensePage(applicationName: '듀잇'));
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const JobInfoRegistrationText(textAlign: TextAlign.start),
      ],
    );
  }

  void _openWebUrl(String url) {
    AppUtils.openWebUrl(url);
    Get.find<MainViewController>().closeEndDrawer();
  }
}

class _LegalLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool emphasized;

  const _LegalLink({
    required this.title,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            title,
            style: TextStyle(
              color: emphasized ? AppColors.black : AppColors.g06,
              fontSize: 13,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
              height: 1.40,
            ),
          ),
        ),
      ),
    );
  }
}
