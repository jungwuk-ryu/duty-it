import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BookmarkJobCard extends GetView<BookmarkViewController> {
  final Rx<JobPosting> jobRx;

  const BookmarkJobCard({super.key, required this.jobRx});

  JobPosting get job => jobRx.value;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => controller.openJobDetail(jobRx),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            job.companyName,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => Text(
                            job.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _BookmarkStarButton(
                    onTap: () => controller.unbookmarkJob(jobRx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      job.closeLabel,
                      style: const TextStyle(
                        color: AppColors.main,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.60,
                      ),
                    ),
                    if (job.careerDescription.isNotEmpty)
                      Text(
                        job.careerDescription,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          height: 1.60,
                        ),
                      ),
                    if (job.locationText.isNotEmpty)
                      Text(
                        job.locationText,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          height: 1.60,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkStarButton extends StatelessWidget {
  final Future<void> Function() onTap;

  const _BookmarkStarButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        HapticFeedback.mediumImpact();
        await onTap();
      },
      child: Image.asset(Assets.icons.bookmarkRed.path, width: 40, height: 40),
    );
  }
}
