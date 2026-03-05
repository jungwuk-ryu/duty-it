import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_header_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_week_cell.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get_state_manager/get_state_manager.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime date;
  final CustomCalendarController controller;

  const CustomCalendar({
    super.key,
    required this.date,
    required this.controller,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _startOfWeekSunday(DateTime date) {
    final int offset = date.weekday % 7;
    return AppUtils.dateTime2Date(date.subtract(Duration(days: offset)));
  }

  List<DateTime> _getWeekStartsInMonth(DateTime monthDate) {
    final DateTime startOfMonth = AppUtils.startOfMonth(monthDate);
    final DateTime endOfMonth = AppUtils.endOfMonth(monthDate);

    final DateTime firstWeekStart = _startOfWeekSunday(startOfMonth);
    final int startOffset = startOfMonth.weekday % 7;
    final int daysInMonth = endOfMonth.day;
    final int weekCount = (startOffset + daysInMonth + 6) ~/ 7;

    return List.generate(
      weekCount,
      (i) => firstWeekStart.add(Duration(days: 7 * i)),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> weekStarts = _getWeekStartsInMonth(widget.date);

    return CustomScrollView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            CustomCalendarHeaderSection(),
            SizedBox(height: 8),
            ...List.generate(weekStarts.length, (i) {
              return CustomCalendarWeekCell(
                date: weekStarts[i],
                calendarMonth: widget.date.month,
                events: widget.controller.events,
                controller: widget.controller,
              );
            }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                DateTime selectedDate = widget.controller.currentDateTime;
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
            SizedBox(height: 4),
          ]),
        ),
        Obx(() {
          var events = widget.controller.getEventsByDay(
            widget.controller.currentDateTime,
          );
          if (events.isEmpty) {
            return SliverToBoxAdapter(child: CustomCalendarEventCard(null));
          }

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
