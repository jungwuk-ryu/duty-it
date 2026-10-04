import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/widgets/job_posting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JobCard extends StatelessWidget {
  final Rx<JobPosting> jobRx;
  final VoidCallback onTap;

  const JobCard({super.key, required this.jobRx, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => JobPostingTile(
        job: jobRx.value,
        onTap: onTap,
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await Get.find<JobViewController>().onBookmarkButtonClick(jobRx);
        },
      ),
    );
  }
}
