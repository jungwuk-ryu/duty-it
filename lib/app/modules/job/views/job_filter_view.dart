import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_app_bar.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_career_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_closed_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_employment_section.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_region_section.dart';
import 'package:duty_it/app/widgets/filter_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobFilterView extends GetView<JobFilterViewController> {
  const JobFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return FilterPageScaffold(
      header: const JobFilterAppBar(),
      sections: const [
        JobFilterCareerSection(),
        JobFilterEmploymentSection(),
        JobFilterRegionSection(),
        JobFilterClosedSection(),
      ],
      onApply: controller.onApplyButtonClicked,
    );
  }
}
