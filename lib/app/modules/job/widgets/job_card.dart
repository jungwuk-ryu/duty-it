import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/widgets/tap_scale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'job_bookmark_button.dart';

class JobCard extends StatelessWidget {
  final Rx<JobPosting> jobRx;
  final VoidCallback? onTap;
  JobPosting get job => jobRx.value;

  const JobCard({super.key, required this.jobRx, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
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
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
