import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class JobDetailInfoRowData {
  final String label;
  final String value;
  final Color? valueColor;

  const JobDetailInfoRowData({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class JobDetailInfoRow extends StatelessWidget {
  final JobDetailInfoRowData row;

  const JobDetailInfoRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
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
              style: TextStyle(
                color: row.valueColor ?? AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
