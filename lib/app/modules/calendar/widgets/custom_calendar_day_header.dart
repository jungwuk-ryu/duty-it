import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';

class DayHeader extends StatelessWidget {
  static double heightFor(BuildContext context) =>
      math.max(48, MediaQuery.textScalerOf(context).scale(10) * 1.6 + 12);
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
    final diameter = math.max(
      24.0,
      MediaQuery.textScalerOf(context).scale(10) * 1.6 + 4,
    );
    return Obx(() {
      bool isSelected = AppUtils.isSameDay(date, controller.currentDateTime);
      bool isToday = AppUtils.isSameDay(date, today);
      return Semantics(
        label: '${date.year}년 ${date.month}월 ${date.day}일',
        button: true,
        selected: isSelected,
        onTap: () => controller.currentDateTime = date,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.currentDateTime = date,
          excludeFromSemantics: true,
          child: SizedBox(
            height: heightFor(context),
            child: Center(
              child: Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.main
                      : (isToday
                            ? context.colors.border
                            : AppColors.transparent),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.white
                            : (date.month == calendarMonth
                                  ? context.colors.secondaryText
                                  : context.colors.disabled),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.60,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
