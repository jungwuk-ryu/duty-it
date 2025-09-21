import 'package:flutter/widgets.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';

class DayHeader extends StatelessWidget {
  final CustomCalendarController controller;
  final int calendarMonth;
  final DateTime today;
  final DateTime date;

  const DayHeader({
    super.key,
    required this.date,
    required this.calendarMonth,
    required this.controller,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          bool isSelected = AppUtils.isSameDay(
            date,
            controller.currentDateTime,
          );
          bool isToday = AppUtils.isSameDay(date, today);
          return Container(
            height: 16,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.black
                  : (isToday ? AppColors.g03 : AppColors.transparent),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: isSelected
                      ? AppColors.white
                      : (date.month == calendarMonth
                            ? AppColors.g07
                            : AppColors.g03),
                  fontSize: 10,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.60,
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 3),
      ],
    );
  }
}
