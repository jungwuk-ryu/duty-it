import 'dart:ui';

import 'package:duty_it/app/core/utils/app_utils.dart';

class CalendarEvent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String url;

  late final DateTime startDay = AppUtils.calendarDay(startDate);
  late final DateTime endDay = AppUtils.calendarDay(endDate);

  bool includesDay(DateTime day) =>
      !day.isBefore(startDay) && !day.isAfter(endDay);

  CalendarEvent({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.url,
  });
}
