import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/modules/calendar/controllers/date_selection_modal_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/date_selection_bottom_modal.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/models/event.dart';

class CalendarViewController extends GetxController {
  static const String _cacheStorageName = "calendarCache";

  final Rx<DateTime> _currentDate = DateTime.now().obs;
  DateTime get currentDate => _currentDate.value;
  set currentDate(value) => _currentDate.value = value;

  static const int initPage = 2000;
  PageController pageController = PageController(initialPage: initPage);

  late Future<GetStorage> _cacheStorageFuture;

  @override
  void onInit() {
    super.onInit();
    _cacheStorageFuture = _initStorage();
  }

  Future<GetStorage> _initStorage() async {
    await GetStorage.init(_cacheStorageName);
    return GetStorage(_cacheStorageName);
  }

  Future<void> clearCache() async {
    var box = await _cacheStorageFuture;
    await box.erase();
  }

  void showDateSelectionBottomModal() {
    Get.put(DateSelectionModalController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DateSelectionBottomModal(),
    ).whenComplete(() => Get.delete<DateSelectionModalController>());
  }

  String _dateTimeToCacheKey(DateTime dt) {
    return "${dt.year}-${dt.month}";
  }

  Stream<List<CalendarEvent>> getCalendarEvents(DateTime date) async* {
    if (!Get.find<AuthService>().isLoggined()) return;
    
    try {
      var storage = await _cacheStorageFuture;
      var cache = storage.read(_dateTimeToCacheKey(date)) ?? [];
      var events = List<Event>.generate(
        cache.length,
        (i) => Event.fromJson(cache[i]),
      );

      yield events2CalendarEvents(events);
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

    yield events2CalendarEvents(events);
  }

  List<CalendarEvent> events2CalendarEvents(List<Event> events) {
    List<CalendarEvent> cEvents = [];
    List<Color> colors = [AppColors.cal3, AppColors.cal2, AppColors.cal1];
    Map<EventType, Color> colorMap = {};
    var types = EventType.values;
    for (int i = 0; i < types.length; i++) {
      EventType type = types[i];
      colorMap[type] = colors[i % colors.length];
    }

    for (int i = 0; i < events.length; i++) {
      Event event = events[i];
      Color color = colorMap[event.eventType] ?? colors[0];

      cEvents.add(
        CalendarEvent(
          title: event.title,
          startDate: event.startAt ?? DateTime.now(),
          endDate: event.endAt ?? DateTime.now(),
          color: color,
          url: event.uri,
        ),
      );
    }

    return cEvents;
  }
}
