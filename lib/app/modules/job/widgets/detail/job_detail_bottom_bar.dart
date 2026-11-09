import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/widgets/job_bookmark_button.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobDetailBottomBar extends StatelessWidget {
  final Rx<JobPosting> jobRx;
  final Future<void> Function() onApplyTap;
  final bool isApplyEnabled;

  const JobDetailBottomBar({
    super.key,
    required this.jobRx,
    required this.onApplyTap,
    required this.isApplyEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(32),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AdaptiveContent(
          screenLeft: MediaQuery.paddingOf(context).left,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
            child: Row(
              children: [
                JobBookmarkButton(jobRx: jobRx),
                const SizedBox(width: 8),
                Expanded(
                  child: AppNormalButton(
                    text: '채용정보 제공사이트로 이동',
                    color: isApplyEnabled
                        ? AppColors.main
                        : context.colors.border,
                    onTap: onApplyTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
