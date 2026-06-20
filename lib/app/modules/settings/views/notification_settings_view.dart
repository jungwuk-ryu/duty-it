import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_filter_controller.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_settings_controller.dart';
import 'package:duty_it/app/widgets/app_toggle_button.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({super.key});

  static bool get _showJobBookmarkAlertSetting => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SimpleAppBar(title: '알림 설정', bottomMargin: 0),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: controller.refreshSettings,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 14, 32),
                    children: [
                      _SettingsToggleRow(
                        title: '푸시 알림',
                        checked: controller.pushNoti,
                        onToggleTap: controller.togglePushNoti,
                      ),
                      const SizedBox(height: 14),
                      _SettingsToggleRow(
                        title: '캘린더 알림',
                        subtitle: '북마크한 일정의 캘린더 알림을 받아볼 수 있어요',
                        checked: controller.calendarNoti,
                        onToggleTap: controller.toggleCalendarNoti,
                      ),
                      const SizedBox(height: 14),
                      _SettingsToggleRow(
                        title: '혜택 및 소식 알림',
                        subtitle: '서비스 소식과 혜택 정보를 받아볼 수 있어요',
                        checked: controller.marketingNoti,
                        onToggleTap: controller.toggleMarketingNoti,
                      ),
                      const SizedBox(height: 22),
                      const _SectionTitle('행사'),
                      const SizedBox(height: 8),
                      _SettingsToggleRow(
                        title: '북마크한 행사공고 알림',
                        subtitle: '북마크한 공고의 주요 일정과 모집 마감을 안내드려요',
                        checked: controller.eventBookmarkNoti,
                        onToggleTap: controller.toggleEventBookmarkNoti,
                      ),
                      const SizedBox(height: 14),
                      _SettingsToggleRow(
                        title: '행사공고 맞춤 알림',
                        subtitle: '설정한 조건에 맞는 새 행사공고를 안내드려요',
                        checked: controller.eventCustomNoti,
                        onToggleTap: controller.toggleEventCustomNoti,
                      ),
                      const SizedBox(height: 12),
                      _ManageRow(
                        title: '행사공고 맞춤 알림 관리',
                        enabled: controller.eventCustomNoti,
                        count: controller.eventCustomCount,
                        onTap: () => controller.openCustomFilter(
                          NotificationFilterMode.event,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle('채용'),
                      const SizedBox(height: 8),
                      if (_showJobBookmarkAlertSetting) ...[
                        const _UnsupportedToggleRow(
                          title: '북마크한 채용공고 알림',
                          subtitle: '서버 지원 전까지 맞춤 알림으로 받아볼 수 있어요',
                        ),
                        const SizedBox(height: 14),
                      ],
                      _SettingsToggleRow(
                        title: '채용공고 맞춤 알림',
                        subtitle: '설정한 조건에 맞는 새 채용공고를 안내드려요',
                        checked: controller.jobCustomNoti,
                        onToggleTap: controller.toggleJobCustomNoti,
                      ),
                      const SizedBox(height: 12),
                      _ManageRow(
                        title: '채용공고 맞춤 알림 관리',
                        enabled: controller.jobCustomNoti,
                        count: controller.jobCustomCount,
                        onTap: () => controller.openCustomFilter(
                          NotificationFilterMode.job,
                        ),
                      ),
                    ],
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.60,
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool checked;
  final Future<void> Function() onToggleTap;

  const _SettingsToggleRow({
    required this.title,
    this.subtitle,
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
                style: _NotificationStyles.primary,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _NotificationStyles.secondary,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        AppToggleButton(checked: checked, onTap: onToggleTap),
      ],
    );
  }
}

class _UnsupportedToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _UnsupportedToggleRow({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _NotificationStyles.disabledPrimary),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _NotificationStyles.disabledSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        AppToggleButton(checked: false, enabled: false, onTap: () async {}),
      ],
    );
  }
}

class _ManageRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final int count;
  final VoidCallback onTap;

  const _ManageRow({
    required this.title,
    required this.enabled,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.black : AppColors.g03;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            Expanded(
              child: Text(
                count > 0 ? '$title $count' : title,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 28),
          ],
        ),
      ),
    );
  }
}

class _NotificationStyles {
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

  static const disabledPrimary = TextStyle(
    color: AppColors.g04,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.60,
  );

  static const disabledSecondary = TextStyle(
    color: AppColors.g04,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.60,
  );
}
