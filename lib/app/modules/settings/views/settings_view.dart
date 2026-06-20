import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/settings/widgets/toggle_setting_item.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Column(
                  spacing: 24,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ToggleSettingItem(
                        title: '푸시 알림',
                        checked: controller.pushNoti,
                        onToggleTap: () async =>
                            await controller.togglePushNoti(),
                      ),
                    ),
                    Obx(
                      () => ToggleSettingItem(
                        title: '행사 알림 수신',
                        subtitle: "북마크 해놓은 행사의 모집일정과 행사 시작일을 알려드려요.",
                        checked: controller.bookmarkNoti,
                        onToggleTap: () async =>
                            await controller.toggleBookmarkNoti(),
                        enabled: controller.pushNoti,
                      ),
                    ),
                    // Obx(
                    //   () => ToggleSettingItem(
                    //     title: '캘린더 알림 수신',
                    //     checked: controller.calendarNoti,
                    //     subtitle: "캘린더에 등록해놓은 알림만 발송드려요.",
                    //     onToggleTap: () async => await controller.toggleCalendarNoti(),
                    //     enabled: controller.pushNoti,
                    //   ),
                    // ),
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
                        title: '북마크 - 캘린더 자동 연동',
                        checked: controller.calendarAutoAdd,
                        subtitle: "북마크 설정시, 모집과 행사 일정을 캘린더에 자동으로 등록합니다. ",
                        onToggleTap: () async =>
                            await controller.toggleAutoAdd(),
                      ),
                    ),
                    Obx(
                      () => ToggleSettingItem(
                        title: '캘린더 - 기기 캘린더 행사 포함',
                        checked: controller.includeDeviceEvents,
                        subtitle: "캘린더에 기기에 저장된 일정 정보를 표시합니다.",
                        onToggleTap: () =>
                            controller.toggleIncludeDeviceEvents(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(LicensePage(applicationName: "듀잇")),
                      child: Text(
                        "오픈소스 라이선스",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.60,
                          color: AppColors.g05,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => launchUrlString("mailto:contact@dutyit.net"),
                      child: Text(
                        "문의 메일 : contact@dutyit.net",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.60,
                          color: AppColors.g05,
                        ),
                      ),
                    ),
                    Text(
                      "직업정보제공사업 신고번호 : J1205020260001(서울북부 제2026-1호)",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                        color: AppColors.g05,
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
