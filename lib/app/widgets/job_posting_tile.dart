import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/job_list_summary.dart';
import 'package:flutter/material.dart';

/// Shared card for the job list and saved jobs.
class JobPostingTile extends StatelessWidget {
  final JobPosting job;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const JobPostingTile({
    super.key,
    required this.job,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final facts = [
      JobListSummary.location(job.locationText),
      JobListSummary.career(job.careerText ?? ''),
      job.educationText,
      JobListSummary.salary(job.salaryText ?? ''),
    ].whereType<String>().where((value) => value.isNotEmpty).toList();
    final deadline = job.closeLabel.replaceFirst(RegExp(r'^D\s*-\s*'), 'D-');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(11),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            deadline,
                            style: TextStyle(
                              color: deadline.startsWith('D-')
                                  ? AppColors.main
                                  : AppColors.g05,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            job.companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.g05,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: job.isBookmarked ? '북마크 해제' : '북마크 저장',
                      onPressed: onBookmarkTap,
                      icon: Icon(
                        job.isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 21,
                        color: job.isBookmarked
                            ? AppColors.main
                            : AppColors.g05,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  job.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (facts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    facts.join('  ·  '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.g05,
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
