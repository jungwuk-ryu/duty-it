import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class JobDetailChipWrap extends StatelessWidget {
  final List<String> chips;

  const JobDetailChipWrap({super.key, required this.chips});

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) {
      return const Text(
        '-',
        style: TextStyle(
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.60,
        ),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: chips
          .map(
            (chip) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.g03),
              ),
              child: Text(
                chip,
                style: const TextStyle(
                  color: AppColors.g06,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
