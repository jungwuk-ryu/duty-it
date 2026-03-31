import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/job_close_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'job_bookmark_button.dart';

class JobCard extends StatelessWidget {
  final Rx<JobPosting> jobRx;
  JobPosting get job => jobRx.value;

  const JobCard({super.key, required this.jobRx});

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
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
                        Text(
                          job.companyName,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  JobBookmarkButton(jobRx: jobRx),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    _closingLabel(),
                    style: const TextStyle(
                      color: AppColors.main,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                  if (job.careerDescription.isNotEmpty)
                    Text(
                      job.careerDescription,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        height: 1.60,
                      ),
                    ),
                  if (_locationText.isNotEmpty)
                    Text(
                      _locationText,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        height: 1.60,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _locationText {
    if (job.location.isNotEmpty) return job.location;

    final region = job.workRegion?.displayName ?? '';
    if (region.isEmpty) return job.workDistrict;
    if (job.workDistrict.isEmpty) return region;

    return '$region ${job.workDistrict}';
  }

  String _closingLabel() {
    switch (job.closeType) {
      case JobCloseType.onHire:
        return '채용시 마감';
      case JobCloseType.ongoing:
        return '상시채용';
      case JobCloseType.fixed:
      case JobCloseType.unknown:
        final expiresAt = job.expiresAt;
        if (expiresAt == null) {
          return '상시채용';
        }
        final now = DateUtils.dateOnly(DateTime.now());
        final target = DateUtils.dateOnly(expiresAt);
        final diff = target.difference(now).inDays;
        if (diff < 0) {
          return '마감';
        }
        return 'D - ${diff.toString().padLeft(2, '0')}';
    }
  }
}
