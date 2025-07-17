import 'package:flutter/material.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class CalendarTitleText extends StatelessWidget {
  final DateTime dt;

  const CalendarTitleText({super.key, required this.dt});

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
