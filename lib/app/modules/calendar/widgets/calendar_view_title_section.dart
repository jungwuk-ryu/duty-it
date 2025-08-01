import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CalendarViewTitleSection extends StatelessWidget {
  final DateTime dt;

  const CalendarViewTitleSection({super.key, required this.dt});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${dt.month}월",
      style: TextStyle(
        color: AppColors.black,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.60,
      ),
    );
  }
}
