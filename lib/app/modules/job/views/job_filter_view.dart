import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_app_bar.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_career_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_closed_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_employment_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_region_section.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobFilterView extends GetView<JobFilterViewController> {
  const JobFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const JobFilterAppBar(),
            const SizedBox(height: 8),
            const ColoredBox(
              color: AppColors.g01,
              child: SizedBox(width: double.infinity, height: 8),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: const [
                    SizedBox(height: 24),
                    JobFilterCareerSection(),
                    SizedBox(height: 24),
                    JobFilterEmploymentSection(),
                    SizedBox(height: 24),
                    JobFilterRegionSection(),
                    SizedBox(height: 24),
                    JobFilterClosedSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: AppNormalButton(
                text: '필터 적용',
                onTap: controller.onApplyButtonClicked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
