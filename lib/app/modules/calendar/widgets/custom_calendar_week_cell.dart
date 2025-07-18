import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/app/core/constants/app_colors.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';
import 'package:myapp/app/modules/calendar/widgets/custom_calendar_day_header.dart';

class CustomCalendarWeekCell extends StatelessWidget {
  final DateTime date;

  const CustomCalendarWeekCell({super.key, required this.date});

  DateTime getStartOfWeekSunday(DateTime date) {
    int offset = date.weekday % 7;
    return date.subtract(Duration(days: offset));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startOfWeek = getStartOfWeekSunday(date);

    return SizedBox(
      height: 72.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: List.generate(7, (i) {
                final currentDate = startOfWeek.add(Duration(days: i));
                return Expanded(
                  child: DayHeader(
                    date: currentDate,
                    calendarMonth: date.month,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: DayEventRow(
              date: startOfWeek,
              events: [
                CalendarEvent(
                  title: "어떤 세미나",
                  startDate: startOfWeek,
                  endDate: startOfWeek.add(Duration(days: 1)),
                  color: AppColors.cal2,
                ),
                CalendarEvent(
                  title: "어떤 세미나2",
                  startDate: startOfWeek,
                  endDate: startOfWeek.add(Duration(days: 1)),
                  color: AppColors.cal2,
                ),
                CalendarEvent(
                  title: "어떤 세미나3",
                  startDate: startOfWeek.add(Duration(days: 2)),
                  endDate: startOfWeek.add(Duration(days: 4)),
                  color: AppColors.cal2,
                ),
                CalendarEvent(
                  title: "어떤 세미나4",
                  startDate: startOfWeek.add(Duration(days: 6)),
                  endDate: startOfWeek.add(Duration(days: 9)),
                  color: AppColors.cal2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DayEventRow extends StatelessWidget {
  final List<CalendarEvent> events;
  final DateTime date;

  const DayEventRow({super.key, required this.events, required this.date});

  DateTime getStartOfWeekSunday(DateTime date) {
    int offset = date.weekday % 7;
    return AppUtils.dateTime2Date(date
        .subtract(Duration(days: offset)));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startOfWeek = getStartOfWeekSunday(date);
    List<Widget> children = [];
    double width = MediaQuery.of(context).size.width / 7;

    int eventIdx = 0;
    for (int i = 0; i < 7; i++) {
      final currentDate = startOfWeek.add(Duration(days: i));

      bool foundEvent = false;
      while (eventIdx < events.length) {
        var event = events[eventIdx];
        if (event.startDate.isBefore(currentDate)) {
          eventIdx++;
          continue;
        }
        if (AppUtils.isSameDay(event.startDate, currentDate)) {
          foundEvent = true;
          break;
        }
        break;
      }
      if (!foundEvent) {
        children.add(SizedBox(width: width));
        continue;
      }
      if (eventIdx >= events.length) break;

      var event = events[eventIdx++];
      bool isStart = AppUtils.isSameDay(event.startDate, currentDate);
      int diffDays = min(
        event.endDate.difference(currentDate).inDays,
        startOfWeek.add(Duration(days: 6)).difference(currentDate).inDays,
      );
      i += diffDays;
      double widgetWidth = width * (diffDays + 1);
      bool isEnd = !startOfWeek.add(Duration(days: 6)).isBefore(event.endDate);

      children.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          width: widgetWidth,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(isStart ? 4.r : 0),
              right: Radius.circular(isEnd ? 4.r : 0),
            ),
          ),
          child: Text(
            event.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 8,
              fontWeight: FontWeight.w500,
              height: 1.60,
            ),
          ),
        ),
      );
    }

    return Row(children: children, spacing: 4.w);
  }
}

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

