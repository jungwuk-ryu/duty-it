import 'package:duty_it/app/modules/settings/widgets/toggle_setting_item.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/settings_view_controller.dart';

class SettingsView extends GetView<SettingsViewController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleAppBar(title: '앱 설정'),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
                child: Column(
                  spacing: 24.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ToggleSettingItem(
                        text: '푸시 알림',
                        checked: controller.pushNoti,
                        onToggleTap: () => controller.togglePushNoti(),
                        enabled: true,
                      ),
                    ),
                    // Obx(
                    //   () => ToggleSettingItem(
                    //     text: '마케팅 알림 수신',
                    //     checked: controller.marketingNoti,
                    //     onToggleTap: () => controller.toggleMarketingNoti(),
                    //     enabled: controller.pushNoti,
                    //   ),
                    // ),
                    Obx(
                      () => ToggleSettingItem(
                        text: '행사 알림 수신',
                        checked: controller.bookmarkNoti,
                        onToggleTap: () => controller.toggleBookmarkNoti(),
                        enabled: controller.pushNoti,
                      ),
                    ),
                    Obx(
                      () => ToggleSettingItem(
                        text: '캘린더 알림 수신',
                        checked: controller.calendarNoti,
                        onToggleTap: () => controller.toggleCalendarNoti(),
                        enabled: controller.pushNoti,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
