import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class DrawerCategorySection extends StatelessWidget {
  const DrawerCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "카테고리 1",
          style: TextStyle(
            color: AppColors.g05,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "필요 페이지",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.60,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "필요 페이지",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.60,
          ),
        ),
      ],
    );
  }
}
