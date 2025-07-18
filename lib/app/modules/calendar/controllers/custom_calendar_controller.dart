import 'package:get/get.dart';
import 'package:myapp/app/core/utils/app_utils.dart';
import 'package:myapp/app/modules/calendar/models/calendar_event.dart';

class CustomCalendarController {
  final Rx<DateTime> _currentDateTime = DateTime.now().obs;
  get currentDateTime => _currentDateTime.value;
  set currentDateTime(value) => _currentDateTime.value = value;

  final RxList<CalendarEvent> _events = RxList();

  List<CalendarEvent> get events => _events.value;
  set events(List<CalendarEvent> events) => _events.value = events;

  List<CalendarEvent> getEventsByDay(DateTime date) {
    return events
        .where((e) => AppUtils.isDateWithin(date, e.startDate, e.endDate))
        .toList();
  }
}
