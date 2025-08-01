import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/calendar_view_title_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsetsGeometry.only(left: 16.w),
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
          height: 8.h,
          decoration: BoxDecoration(color: const Color(0xFFEEEEEE)),
        ),
        SizedBox(height: 16.h),
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
              DateTime month = now.copyWith(month: now.month + i - CalendarViewController.initPage);
              var calendarController = CustomCalendarController(month);

              controller.getCalendarEvents(month).then((v) {
                calendarController.events = v;
              });

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
