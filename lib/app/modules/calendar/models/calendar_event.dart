import 'dart:ui';

class CalendarEvent {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String url;

  CalendarEvent({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.url,
  });
}
