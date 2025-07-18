import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/controllers/custom_calendar_controller.dart';

class DayHeader extends StatelessWidget {
  final CustomCalendarController controller;
  final int calendarMonth;
  final DateTime date;

  const DayHeader({super.key, required this.date, required this.calendarMonth, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Container(
          height: 16.r,
          decoration: BoxDecoration(
            color: AppUtils.isSameDay(date, controller.currentDateTime)
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
        )),
        SizedBox(height: 3.h),
      ],
    );
  }
}