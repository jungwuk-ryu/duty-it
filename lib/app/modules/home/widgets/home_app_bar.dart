import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
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
              var con = Get.find<MainViewController>();
              con.openEndDrawer();
            },
            child: Image.asset(
              Assets.icons.hamburger.path,
              width: 40.r,
              height: 40.r,
            ),
          ),
        ],
      ),
    );
  }
}
