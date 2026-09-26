import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/calendar_view_title_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/calendar_view_controller.dart';

class CalendarView extends GetView<CalendarViewController> {
  const CalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
          child: Text(
            '나의 캘린더',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(left: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => controller.showDateSelectionBottomModal(),
            child: Obx(
              () => CalendarViewTitleSection(dt: controller.currentDate),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          decoration: const BoxDecoration(color: AppColors.border),
        ),
        SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) {
              controller.currentDate = now.copyWith(
                month: now.month + i - CalendarViewController.initPage,
              );
            },
            itemBuilder: (_, i) {
              DateTime month = now.copyWith(
                month: now.month + i - CalendarViewController.initPage,
              );
              var calendarController = CustomCalendarController(month);
              calendarController.init();

              return CustomCalendar(
                date: month,
                controller: calendarController,
              );
            },
          ),
        ),
      ],
    );
  }
}
