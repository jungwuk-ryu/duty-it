import 'package:device_calendar_plus/device_calendar_plus.dart' as dcp;
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/date_selection_bottom_modal.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/models/event.dart';

class CalendarViewController extends GetxController {
  static const String deviceEventScheme = "device_event://";
  static const String _cacheStorageName = "calendarCache";

  static const int initPage = 2000;
  final Rx<DateTime> _currentDate = DateTime.now().obs;
  PageController pageController = PageController(initialPage: initPage);

  late Future<GetStorage> _cacheStorageFuture;
  DateTime get currentDate => _currentDate.value;

  set currentDate(value) => _currentDate.value = value;

  Future<void> clearCache() async {
    var box = await _cacheStorageFuture;
    await box.erase();
  }

  List<CalendarEvent> deviceCalEvents2CalendarEvents(
    List<dcp.Event> deviceCalEvents,
  ) {
        return deviceCalEvents
        .map((event) {
          final end = event.endDate;
          var correctedEnd = end;
          if (event.isAllDay && end.hour == 0 && end.minute == 0 && !AppUtils.isSameDay(event.startDate, end)) {
            correctedEnd = end.subtract(Duration(minutes: 1));
          }
            return CalendarEvent(
              title: event.title,
              startDate: event.startDate,
              endDate: correctedEnd,
              color: AppColors.cal1,
              url: "$deviceEventScheme${event.eventId}",);
  })
        .toList();
  }

  List<CalendarEvent> events2CalendarEvents(List<Event> events) {
    List<Color> colors = [AppColors.cal3, AppColors.cal2, AppColors.cal1];  
    final colorMap = {  
      for (var i = 0; i < EventType.values.length; i++) EventType.values[i]: colors[i % colors.length],  
    };  

    return events.map((event) {  
      final color = colorMap[event.eventType] ?? colors[0];  
      return CalendarEvent(  
        title: event.title,  
        startDate: event.startAt ?? DateTime.now(),  
        endDate: event.endAt ?? DateTime.now(),  
        color: color,  
        url: event.uri,  
      );  
    }).toList();  
  }

  Stream<List<CalendarEvent>> getCalendarEvents(DateTime date) async* {
    List<dcp.Event> deviceEvents = [];

    final calService = Get.find<CalendarService>();
    final calPermission = await calService.checkPermission();
    if (calPermission && Get.find<AppSettingsService>().includeDeviceEvents.value) {
      deviceEvents = await calService.retrieveEvents(
        AppUtils.startOfMonth(date),
        AppUtils.endOfMonth(date),
      );
    }

    if (!Get.find<AuthService>().isLoggined()) {
      yield mergeDuitEventsAndDeviceEvents([], deviceEvents);
      return;
    }

    try {
      var storage = await _cacheStorageFuture;
      var cache = storage.read(_dateTimeToCacheKey(date)) ?? [];
      var events = List<Event>.generate(
        cache.length,
        (i) => Event.fromJson(cache[i]),
      );

      yield mergeDuitEventsAndDeviceEvents(events, deviceEvents);
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }

    var apiClient = Get.find<ApiClient>();
    RequestResult<List<Event>> reqResult = await apiClient.getEventsForCalendar(
      year: date.year,
      month: date.month,
    );
    if (reqResult is RequestFail) {
      if (kDebugMode) {
        AppUtils.showSnackBar(
          '${date.year}년 ${date.month}월 캘린더를 불러오지 못했어요.\n${reqResult.serverFail?.message ?? ''}',
        );
      }
      return;
    }

    var reqSuccess = reqResult as RequestSuccess<List<Event>>;
    List<Event> events = reqSuccess.data;

    var storage = await _cacheStorageFuture;
    storage.write(
      _dateTimeToCacheKey(date),
      List.generate(events.length, (i) => events[i].toJson()),
    );

    yield mergeDuitEventsAndDeviceEvents(events, deviceEvents);
  }

  List<CalendarEvent> mergeDuitEventsAndDeviceEvents(
    List<Event> duitEvents,
    List<dcp.Event> deviceEvents,
  ) {
    final calService = Get.find<CalendarService>();
    final duplicatedCalEvents = duitEvents
        .where((e) => calService.isRegistered(e.id.toString()))
        .map((e) => calService.getRegisteredEventId(e.id.toString()))
        .whereType<String>()
        .toSet();

    final convetedDuitEvents = events2CalendarEvents(duitEvents);
    final convertedDeviceEvents = deviceCalEvents2CalendarEvents(
      deviceEvents
          .where((ce) => !duplicatedCalEvents.contains(ce.eventId))
          .toList(),
    );

    return [...convetedDuitEvents, ...convertedDeviceEvents];
  }

  @override
  void onInit() {
    super.onInit();
    _cacheStorageFuture = _initStorage();
  }

  void showDateSelectionBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DateSelectionBottomModal(),
    );
  }

  String _dateTimeToCacheKey(DateTime dt) {
    return "${dt.year}-${dt.month}";
  }

  Future<GetStorage> _initStorage() async {
    await GetStorage.init(_cacheStorageName);
    return GetStorage(_cacheStorageName);
  }
}
