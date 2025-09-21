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
        SizedBox(height: 15),
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
          height: 8,
          decoration: BoxDecoration(color: const Color(0xFFEEEEEE)),
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

              _loadCalendarEvents(month, calendarController);

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

  Future _loadCalendarEvents(
    DateTime date,
    CustomCalendarController calController,
  ) async {
    await for (var events in controller.getCalendarEvents(date)) {
      calController.events = events;
    }
  }
}
