import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class JobDetailInfoRowData {
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const JobDetailInfoRowData({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });
}

class JobDetailInfoRow extends StatelessWidget {
  final JobDetailInfoRowData row;

  const JobDetailInfoRow({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final isInteractive = row.onTap != null;
    final valueColor = row.valueColor ?? AppColors.black;
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
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
              color: isInteractive ? AppColors.main : valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.60,
              decoration: isInteractive ? TextDecoration.underline : null,
              decorationColor: AppColors.main,
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: isInteractive
          ? Semantics(
              button: true,
              label: '${row.label}, ${row.value}, 지도에서 열기',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: row.onTap,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: content,
                    ),
                  ),
                ),
              ),
            )
          : content,
    );
  }
}
