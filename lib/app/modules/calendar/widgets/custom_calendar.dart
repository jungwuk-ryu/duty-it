import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_week_cell.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime date;
  final CustomCalendarController controller;

  const CustomCalendar({
    super.key,
    required this.date,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime startOfMonth = date.copyWith(day: 1);

    return CustomScrollView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            CustomCalendarHeaderSection(),
            SizedBox(height: 8.h),
            ...List.generate(5, (i) {
              final DateTime cDt = startOfMonth.add(Duration(days: 7 * i));
              if (cDt.month != date.month) return SizedBox.shrink();
              return Obx(
                () => CustomCalendarWeekCell(
                  date: cDt,
                  events: controller.events,
                  controller: controller,
                ),
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                DateTime selectedDate = controller.currentDateTime;
                return Text(
                  "${selectedDate.month}월 ${selectedDate.day}일 (${AppUtils.weekDay2Text(selectedDate.weekday)})",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.60,
                  ),
                );
              }),
            ),
            SizedBox(height: 4.h),
          ]),
        ),
        Obx(() {
          var events = controller.getEventsByDay(controller.currentDateTime);

          return SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                events.length,
                (i) => CustomCalendarEventCard(events[i]),
              ),
            ),
          );
        }),
      ],
    );
  }
}
