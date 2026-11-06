import 'dart:async';

import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:duty_it/app/services/calendar_service.dart';
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
  StreamSubscription<int>? _deviceCalendarSubscription;

  StreamSubscription<List<CalendarEvent>>? _eventsSubscription;
  StreamSubscription<int>? _sessionSubscription;
  late final CalendarViewController _calendar =
      Get.find<CalendarViewController>();

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
    _sessionSubscription = _calendar.sessionChanges.listen(
      (_) => _loadCalendarEvents(),
    );
    _deviceCalendarSubscription = Get.find<CalendarService>().revision.listen((
      _,
    ) {
      _loadCalendarEvents();
    });
    _includeDeviceEventsSubscription = _includeDeviceEventsSetting.rxValue
        .listen((_) {
          _loadCalendarEvents();
        });
  }

  void dispose() {
    _eventsSubscription?.cancel();
    _sessionSubscription?.cancel();
    _includeDeviceEventsSubscription?.cancel();
    _deviceCalendarSubscription?.cancel();
  }

  void _loadCalendarEvents() {
    _eventsSubscription?.cancel();
    events.clear();
    _eventsSubscription = _calendar.getCalendarEvents(currentDateTime).listen((
      updated,
    ) {
      events = updated;
    });
  }
}
