import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/calendar/widgets/calendar_title_text.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar.dart';

import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
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
          child: Obx(() => CalendarTitleText(dt: controller.currentDateTime)),
        ),
        Container(
          width: double.infinity,
          height: 8.h,
          decoration: BoxDecoration(color: const Color(0xFFEEEEEE)),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: PageView.builder(
            controller: PageController(initialPage: 2000),
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) {
              controller.currentDateTime = now.copyWith(month: now.month + i - 2000);
            },
            itemBuilder: (_, i) {
              return CustomCalendar(date: now.copyWith(month: now.month + i - 2000));
            },
          ),
        ),
      ],
    );
  }
}
