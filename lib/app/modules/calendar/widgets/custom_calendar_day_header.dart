import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';

class DayHeader extends StatelessWidget {
  final int calendarMonth;
  final DateTime date;

  const DayHeader({super.key, required this.date, required this.calendarMonth});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Column(
      children: [
        Container(
          height: 16.r,
          decoration: BoxDecoration(
            color: AppUtils.isSameDay(date, now)
                ? AppColors.g03
                : AppColors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: date.month == calendarMonth
                    ? AppColors.g07
                    : AppColors.g03,
                fontSize: 10,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
      ],
    );
  }
}