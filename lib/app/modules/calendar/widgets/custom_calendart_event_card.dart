import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';

class CustomCalendartEventCard extends StatelessWidget {
  final String? title;
  final String? subText;
  final Color? backgroundColor;

  const CustomCalendartEventCard({
    super.key,
    this.title,
    this.subText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 7.h, left: 16.w, right: 16.w),
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.g01,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title != null
                ? Text(
                  '$title',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                  ),
                )
                : Text(
                  '일정 없음',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.60,
                  ),
                ),
            subText != null
                ? Text(
                  '$subText',
                  style: TextStyle(
                    color: AppColors.g06,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.60,
                  ),
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
