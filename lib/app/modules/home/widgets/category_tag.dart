import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';

class CategoryTag extends StatelessWidget {
  final String? imageAsset;
  final String name;
  final bool isSelected;

  const CategoryTag({
    super.key,
    required this.isSelected,
    required this.name,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 32.h),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.main : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: BoxBorder.all(
            width: 1,
            color: isSelected ? AppColors.transparent : AppColors.g04,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 16.w,
            vertical: 6.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: imageAsset != null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(imageAsset ?? "", width: 16.r, height: 16.r),
                    SizedBox(width: 4.w),
                  ],
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.g05,
                  fontWeight: FontWeight.w300,
                  height: 1.60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
