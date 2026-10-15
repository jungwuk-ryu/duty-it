import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/app_toggle_button.dart';
import 'package:flutter/material.dart';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DrawerCategorySection extends StatelessWidget {
  const DrawerCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          "설정",
          style: TextStyle(
            color: AppColors.g05,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        if (Get.find<AuthService>().isLoggined())
          _PageItemButton(
            title: "앱 설정",
            onTap: () {
              Get.toNamed(Routes.SETTINGS);
              Get.find<MainViewController>().closeEndDrawer();
            },
          ),
        _PageItemButton(
          title: "행사 제보하기",
          onTap: () async {
            launchUrlString('https://www.dutyit.net/submit-event');
            Get.find<MainViewController>().closeEndDrawer();
          },
        ),
        _PageItemButton(
          title: "피드백 남기기",
          onTap: () async {
            launchUrlString('https://forms.gle/YEUFTzspFMu6xoNW8');
            Get.find<MainViewController>().closeEndDrawer();
          },
        ),
        const _AnalyticsCollectionToggle(),
      ],
    );
  }
}

/// 개인정보 처리방침에서 안내한 이용 통계 수집 거부 설정. 로그인하지 않아도 바꿀 수 있다.
class _AnalyticsCollectionToggle extends StatelessWidget {
  const _AnalyticsCollectionToggle();

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<AppSettingsService>();

    return Obx(() {
      final enabled = settings.analyticsCollectionEnabled.value;

      return MergeSemantics(
        child: Semantics(
          toggled: enabled,
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "이용 통계 수집",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.60,
                      ),
                    ),
                    Text(
                      "서비스 개선을 위한 이용 통계와 오류 정보를 보내요. 끄면 수집이 중단돼요.",
                      style: TextStyle(
                        color: AppColors.g06,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 1.40,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppToggleButton(
                checked: enabled,
                onTap: () => settings.setAnalyticsCollectionEnabled(!enabled),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PageItemButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _PageItemButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.60,
        ),
      ),
    );
  }
}
