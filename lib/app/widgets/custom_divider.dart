import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.g01,
      child: SizedBox(height: 8.h, width: double.infinity),
    );
  }
}
