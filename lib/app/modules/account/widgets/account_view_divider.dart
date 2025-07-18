import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class AccountViewDivider extends StatelessWidget {
  const AccountViewDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      width: double.infinity,
      child: ColoredBox(color: AppColors.g01),
    );
  }
}
