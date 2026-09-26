import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/job_posting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BookmarkJobCard extends GetView<BookmarkViewController> {
  final Rx<JobPosting> jobRx;

  const BookmarkJobCard({super.key, required this.jobRx});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => JobPostingTile(
        job: jobRx.value,
        onTap: () => controller.openJobDetail(jobRx),
        onBookmarkTap: () async {
          HapticFeedback.mediumImpact();
          await controller.unbookmarkJob(jobRx);
        },
      ),
    );
  }
}
