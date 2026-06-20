import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/app_toggle_button.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/settings_view_controller.dart';

class SettingsView extends GetView<SettingsViewController> {
  const SettingsView({super.key});

  static const _registrationNumber =
      '직업정보제공사업 신고번호: J1205020260001(서울북부 제2026-1호)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleAppBar(title: '앱 설정', bottomMargin: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 44, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsNavigationRow(
                      title: '알림 설정',
                      onTap: controller.openNotificationSettings,
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => _SettingsToggleRow(
                        title: '북마크한 공고를 기본 캘린더 앱에 추가하기',
                        subtitle: '북마크한 공고를 휴대폰 기본 캘린더 앱에서도 확인할 수 있어요',
                        checked: controller.calendarAutoAdd,
                        onToggleTap: controller.toggleAutoAdd,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => _SettingsToggleRow(
                        title: '기본 캘린더 일정을 듀잇 캘린더에서 보기',
                        subtitle: '휴대폰 기본 캘린더의 일정을 듀잇 캘린더에 가져올 수 있어요',
                        checked: controller.includeDeviceEvents,
                        onToggleTap: controller.toggleIncludeDeviceEvents,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const _SettingsTextRow(title: '개인 정보 처리 방침'),
                    const SizedBox(height: 26),
                    _SettingsTextRow(
                      title: '오픈소스 라이선스',
                      onTap: () => Get.to(LicensePage(applicationName: '듀잇')),
                    ),
                    const SizedBox(height: 26),
                    _SettingsTextRow(
                      title: '문의 메일 : contact@dutyit.net',
                      onTap: () => launchUrlString('mailto:contact@dutyit.net'),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Center(
                child: Text(
                  _registrationNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.g04,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
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

class _SettingsNavigationRow extends StatelessWidget {
  final String title;
  final Future<void> Function()? onTap;

  const _SettingsNavigationRow({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async => await onTap?.call(),
      child: SizedBox(
        height: 32,
        child: Row(
          children: [
            Text(title, style: _SettingsStyles.primary),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.black, size: 30),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool checked;
  final Future<void> Function() onToggleTap;

  const _SettingsToggleRow({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.onToggleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _SettingsStyles.primary,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _SettingsStyles.secondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        AppToggleButton(checked: checked, onTap: onToggleTap),
      ],
    );
  }
}

class _SettingsTextRow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SettingsTextRow({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Text(title, style: _SettingsStyles.muted);
    if (onTap == null) return text;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: text,
    );
  }
}

class _SettingsStyles {
  static const primary = TextStyle(
    color: AppColors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.60,
  );

  static const secondary = TextStyle(
    color: AppColors.g05,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.60,
  );

  static const muted = TextStyle(
    color: AppColors.g05,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.60,
  );
}
