import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobFilterAppBar extends GetView<JobFilterViewController> {
  const JobFilterAppBar({super.key});

  @override
  Widget build(BuildContext context) => SimpleAppBar(
    title: '채용 검색 필터',
    endChildren: [
      TextButton(
        onPressed: controller.onResetSettingsButtonClicked,
        style: TextButton.styleFrom(
          minimumSize: const Size(64, 48),
          foregroundColor: context.colors.secondaryText,
        ),
        child: const Text('초기화', style: TextStyle(fontSize: 16)),
      ),
      const SizedBox(width: 14),
    ],
  );
}
