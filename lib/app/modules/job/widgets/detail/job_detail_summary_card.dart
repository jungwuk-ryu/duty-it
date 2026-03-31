import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:flutter/material.dart';

class JobDetailSummaryCard extends StatelessWidget {
  final JobPosting job;

  const JobDetailSummaryCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final qualificationRows = <_SummaryRow>[
      if (job.careerText != null) _SummaryRow('경력', job.careerText!),
      if (job.educationText != null) _SummaryRow('학력', job.educationText!),
    ];
    final workConditionRows = <_SummaryRow>[
      if (job.salaryText != null) _SummaryRow('임금', job.salaryText!),
      if (job.locationText.isNotEmpty) _SummaryRow('지역', job.locationText),
    ];
    final employmentRows = <_SummaryRow>[
      if (job.employmentTypeText != null)
        _SummaryRow('고용형태', job.employmentTypeText!),
    ];

    final sections = <_SummarySection>[
      _SummarySection(title: '지원자격', rows: qualificationRows),
      _SummarySection(title: '근무조건', rows: workConditionRows),
      _SummarySection(title: '고용형태', rows: employmentRows),
    ].where((section) => section.rows.isNotEmpty).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.g03),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(sections.length, (index) {
          final section = sections[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == sections.length - 1 ? 0 : 20,
            ),
            child: _SummarySectionWidget(section: section),
          );
        }),
      ),
    );
  }
}

class _SummarySection {
  final String title;
  final List<_SummaryRow> rows;

  const _SummarySection({required this.title, required this.rows});
}

class _SummaryRow {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);
}

class _SummarySectionWidget extends StatelessWidget {
  final _SummarySection section;

  const _SummarySectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        const SizedBox(height: 6),
        ...section.rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    row.label,
                    style: const TextStyle(
                      color: AppColors.g05,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.value,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.60,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
