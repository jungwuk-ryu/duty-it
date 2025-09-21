import 'package:get/get.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';

class CustomCalendarController {
  final Rx<DateTime> _currentDateTime = DateTime.now().obs;
  get currentDateTime => _currentDateTime.value;
  set currentDateTime(value) => _currentDateTime.value = value;

  final RxList<CalendarEvent> _events = RxList();

  RxList<CalendarEvent> get events => _events;
  set events(List<CalendarEvent> events) => _events.value = events;

  CustomCalendarController(DateTime calendarDate) {
    if (currentDateTime.month != calendarDate.month) {
      currentDateTime = AppUtils.dateTime2Date(calendarDate).copyWith(day: 1);
    }
  }

  List<CalendarEvent> getEventsByDay(DateTime date) {
    return events
        .where((e) => AppUtils.isDateWithin(date, e.startDate, e.endDate))
        .toList();
  }
}
