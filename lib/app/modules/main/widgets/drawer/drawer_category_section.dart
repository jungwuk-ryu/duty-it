import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            color: const Color(0xFF949494),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "필요 페이지",
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.60,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "필요 페이지",
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.60,
          ),
        ),
      ],
    );
  }
}
