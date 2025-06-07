import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTag extends StatelessWidget {
  static const int selectedBackColor = 0xFF333333;
  static const int selectedtextColor = 0xFFFFFFFF;
  static const int unselectedBackColor = 0x00000000;
  static const int unselectedTextColor = 0xFF8D8D8D;

  final String category;
  final bool isSelected;

  const CategoryTag({
    super.key,
    required this.isSelected,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        color: Color(isSelected ? selectedBackColor : unselectedBackColor),
        borderRadius: BorderRadius.circular(16.r),
        border: BoxBorder.all(
          width: 1,
          color: isSelected ? Colors.transparent : const Color(0xFFBBBBBB),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: Color(
                isSelected ? selectedtextColor : unselectedTextColor,
              ),
              fontWeight: FontWeight.w300,
              height: 1.60,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
