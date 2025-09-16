import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarViewTitleSection extends StatelessWidget {
  final DateTime dt;

  const CalendarViewTitleSection({super.key, required this.dt});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${dt.month}월",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.60,
          ),
        ),
        SizedBox(width: 7.w),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${dt.year}',
                  style: TextStyle(
                    color: const Color(0xFF949494),
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.60,
                  ),
                ),
                SizedBox(width: 4),
                Image.asset(
                  Assets.icons.go.path,
                  width: 16.r,
                  height: 16.r,
                ),
              ],
            ),
            SizedBox(height: 7.h),
          ],
        ),
      ],
    );
  }
}
