import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
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
      ],
    );
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
