import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/widgets/detail/job_detail_info_row.dart';
import 'package:flutter/material.dart';

class JobDetailSection extends StatelessWidget {
  final String title;
  final List<JobDetailInfoRowData> rows;

  const JobDetailSection({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.60,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map((row) => JobDetailInfoRow(row: row)),
        ],
      ),
    );
  }
}
