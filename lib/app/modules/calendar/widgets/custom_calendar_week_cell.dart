import 'dart:math';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_day_header.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomCalendarWeekCell extends StatelessWidget {
  final CustomCalendarController controller;
  final int calendarMonth;
  final DateTime date;
  final List<CalendarEvent> events;

  const CustomCalendarWeekCell({
    super.key,
    required this.date,
    required this.calendarMonth,
    required this.events,
    required this.controller,
  });

  DateTime getStartOfWeekSunday(DateTime date) {
    int offset = date.weekday % 7;
    return AppUtils.dateTime2Date(date.subtract(Duration(days: offset)));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final DateTime now = DateTime.now();
      final DateTime startOfWeek = getStartOfWeekSunday(date);
      final DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      final maxLines = 2;

      final (rows, usedEvents) = _distributeEvents(
        events,
        maxLines,
        startOfWeek,
        endOfWeek,
      );
      final notUsedEvents = events
          .where((e) => !usedEvents.contains(e))
          .toList();
      final GlobalKey key = GlobalKey();

      return GestureDetector(
        key: key,
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          final RenderBox box =
              key.currentContext!.findRenderObject() as RenderBox;
          final Size size = box.size;

          controller.currentDateTime = startOfWeek.add(
            Duration(
              days: (details.localPosition.dx / (size.width / 7)).toInt(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Row(
              children: List.generate(7, (i) {
                final currentDate = startOfWeek.add(Duration(days: i));
                return Expanded(
                  child: DayHeader(
                    today: now,
                    date: currentDate,
                    calendarMonth: calendarMonth,
                    controller: controller,
                  ),
                );
              }),
            ),
            SizedBox(
              height: 16,
              child: _WeekEventRow(
                startOfWeek: startOfWeek,
                endOfWeek: endOfWeek,
                events: rows[0],
              ),
            ),
            SizedBox(
              height: 16,
              child: _WeekEventRow(
                startOfWeek: startOfWeek,
                endOfWeek: endOfWeek,
                events: rows[1],
              ),
            ),
            SizedBox(
              height: 16,
              child: _WeekEventLastRow(
                startOfWeek: startOfWeek,
                endOfWeek: endOfWeek,
                events: notUsedEvents,
              ),
            ),
          ],
        ),
      );
    });
  }

  (List<List<CalendarEvent>>, Set<CalendarEvent>) _distributeEvents(
    List<CalendarEvent> events,
    int maxLines,
    DateTime startOfWeek,
    DateTime endOfWeek,
  ) {
    final rows = List.generate(maxLines, (_) => <CalendarEvent>[]);
    final used = <CalendarEvent>{};

    for (final event in events) {
      for (int i = 0; i < maxLines; i++) {
        final row = rows[i];
        final hasOverlap = row.any(
          (e) =>
              !(event.endDate.isBefore(e.startDate) ||
                  event.startDate.isAfter(e.endDate)),
        );

        if (!hasOverlap) {
          row.add(event);
          used.add(event);
          break;
        }
      }
    }

    return (rows, used);
  }
}

class _WeekEventRow extends StatelessWidget {
  final List<CalendarEvent> events;
  final DateTime startOfWeek;
  final DateTime endOfWeek;

  const _WeekEventRow({
    required this.events,
    required this.startOfWeek,
    required this.endOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final double width = constraints.maxWidth / 7;

        List<Widget> children = [];

        int i = 0;
        while (i < 7) {
          final currentDate = startOfWeek.add(Duration(days: i));

          int eventIdx = 0;
          bool foundEvent = false;
          while (eventIdx < events.length) {
            var event = events[eventIdx];

            if (AppUtils.isDateWithin(
              currentDate,
              event.startDate,
              event.endDate,
            )) {
              foundEvent = true;
              break;
            }

            eventIdx++;
          }

          if (!foundEvent) {
            children.add(SizedBox(width: width));
            i++;
            continue;
          }

          var event = events[eventIdx++];
          int diffDays = min(
            event.endDate.difference(currentDate).inDays,
            endOfWeek.difference(currentDate).inDays,
          );
          final rowEndDate = currentDate.add(Duration(days: diffDays));
          final normalizedEventEndDate = AppUtils.dateTime2Date(event.endDate);

          bool isStart = AppUtils.isSameDay(event.startDate, currentDate);
          bool isEnd = !rowEndDate.isBefore(normalizedEventEndDate);

          double widgetWidth = width * (diffDays + 1);
          if (isStart) widgetWidth -= 2;
          if (isEnd) widgetWidth -= 2;

          children.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.only(
                left: isStart ? 2 : 0,
                right: isEnd ? 2 : 0,
              ),
              width: widgetWidth,
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(isStart ? 4 : 0),
                  right: Radius.circular(isEnd ? 4 : 0),
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

          i += diffDays + 1;
        }

        return Row(children: children);
      },
    );
  }
}

class _WeekEventLastRow extends StatelessWidget {
  final List<CalendarEvent> events;
  final DateTime startOfWeek;
  final DateTime endOfWeek;

  const _WeekEventLastRow({
    required this.events,
    required this.startOfWeek,
    required this.endOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final double width = constraints.maxWidth / 7;

        List<Widget> children = [];

        for (int i = 0; i < 7; i++) {
          final currentDate = startOfWeek.add(Duration(days: i));

          int eventCount = 0;
          for (int eventIdx = 0; eventIdx < events.length; eventIdx++) {
            var event = events[eventIdx];
            if (AppUtils.isDateWithin(
              currentDate,
              event.startDate,
              event.endDate,
            )) {
              eventCount++;
            }
          }

          if (eventCount < 1) {
            children.add(SizedBox(width: width));
          } else {
            children.add(
              SizedBox(
                width: width,
                child: Center(
                  child: Text(
                    "+ $eventCount개",
                    style: TextStyle(
                      color: const Color(0xFF6F6F6F),
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      height: 1.60,
                    ),
                  ),
                ),
              ),
            );
          }
        }

        return Row(children: children);
      },
    );
  }
}
