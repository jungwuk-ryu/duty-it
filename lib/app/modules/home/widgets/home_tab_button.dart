import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  const HomeTabButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final Duration animationDuration = Duration(milliseconds: 100);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: 148.w,
        child: Column(
          children: [
            AnimatedDefaultTextStyle(
              style: TextStyle(
                color: isSelected ? AppColors.black : AppColors.g04,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
              duration: animationDuration,
              child: Text(title),
            ),
            SizedBox(height: 8.h),
            AnimatedContainer(
              height: 4.h,
              width: 148.w,
              color: isSelected ? AppColors.main : Colors.transparent,
              duration: animationDuration,
            ),
          ],
        ),
      ),
    );
  }
}
