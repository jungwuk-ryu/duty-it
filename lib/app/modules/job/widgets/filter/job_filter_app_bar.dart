import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobFilterAppBar extends GetView<JobFilterViewController> {
  const JobFilterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: Get.back,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Image.asset(
                Assets.icons.backLeft.path,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Text(
            '채용 검색 필터',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.60,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: controller.onResetSettingsButtonClicked,
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Text(
                '초기화',
                style: TextStyle(
                  color: AppColors.g04,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.60,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
