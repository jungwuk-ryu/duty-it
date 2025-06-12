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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: 148.w,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? const Color(0xFF333333)
                        : const Color(0xFFA3A3A3),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 4.h,
              width: 148.w,
              child: ColoredBox(
                color: isSelected ? Colors.black : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
