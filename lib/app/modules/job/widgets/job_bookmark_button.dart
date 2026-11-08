import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JobBookmarkButton extends StatelessWidget {
  final Rx<JobPosting> jobRx;

  JobPosting get job => jobRx.value;
  JobViewController get _controller => Get.find<JobViewController>();

  const JobBookmarkButton({super.key, required this.jobRx});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        HapticFeedback.mediumImpact();
        await _controller.onBookmarkButtonClick(jobRx);
      },
      child: Obx(
        () => AppAssetIcon(
          asset: job.isBookmarked
              ? Assets.icons.bookmarkRed.path
              : Assets.icons.bookmark.path,
          color: job.isBookmarked ? context.colors.accent : context.colors.icon,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
