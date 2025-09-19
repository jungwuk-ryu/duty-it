import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  HomeViewController get controller => Get.find<HomeViewController>();

  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          Image.asset(Assets.icons.logo.path, width: 16, height: 16),
          SizedBox(width: 8),
          Text(
            "듀잇 - Du it!",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              controller.openNotificationsPage();
            },
            child: SizedBox(
              width: 14,
              height: 18,
              child: Obx(
                () => Image.asset(
                  controller.hasNewNotification
                      ? Assets.icons.bellNew.path
                      : Assets.icons.bell.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 13),
          GestureDetector(
            onTap: () {
              Get.find<MainViewController>().openEndDrawer();
            },
            child: Image.asset(
              Assets.icons.hamburger.path,
              width: 18,
              height: 14,
            ),
          ),
        ],
      ),
    );
  }
}
