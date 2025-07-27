import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/custom_toggle_button.dart';
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
                    Row(
                      children: [
                        Text(
                          '푸시 알림',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.60,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Obx(
                          () => CustomToggleButton(
                            checked: controller.pushNoti,
                            onTap: () => controller.togglePushNoti(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '마케팅 수신 알림',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.60,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Obx(
                          () => CustomToggleButton(
                            checked: controller.marketingNoti,
                            onTap: () => controller.toggleMarketingNoti(),
                          ),
                        ),
                      ],
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
