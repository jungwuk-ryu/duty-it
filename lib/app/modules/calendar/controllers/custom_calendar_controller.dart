import 'dart:async';

import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';

class CustomCalendarController {
  final Rx<DateTime> _currentDateTime = DateTime.now().obs;
  get currentDateTime => _currentDateTime.value;
  set currentDateTime(value) => _currentDateTime.value = value;

  final RxList<CalendarEvent> _events = RxList();
  final AppSetting _includeDeviceEventsSetting =
      Get.find<AppSettingsService>().includeDeviceEvents;
  StreamSubscription<dynamic>? _includeDeviceEventsSubscription;

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

  void init() {
    _loadCalendarEvents();
    _includeDeviceEventsSubscription = _includeDeviceEventsSetting.rxValue.listen((_) {
      _loadCalendarEvents();
    });
  }

  void dispose() {
    _includeDeviceEventsSubscription?.cancel();
  }

  Future _loadCalendarEvents() async {
    events.clear();
    var calController = Get.find<CalendarViewController>();
    await for (var newEvents in calController.getCalendarEvents(currentDateTime)) {
      events = newEvents;
    }
  }
}
