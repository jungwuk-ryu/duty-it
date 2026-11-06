import 'dart:async';

import 'package:device_calendar_plus/device_calendar_plus.dart' as dcp;
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/date_selection_bottom_modal.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/models/event.dart';

class CalendarViewController extends GetxController {
  static const String deviceEventScheme = "device_event://";
  static const String _cacheStorageName = "calendarCache";

  CalendarViewController({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final RxInt _sessionRevision = 0.obs;
  Stream<int> get sessionChanges => _sessionRevision.stream;
  StreamSubscription<User?>? _authSubscription;

  static const int initPage = 2000;
  final Rx<DateTime> _currentDate = DateTime.now().obs;
  PageController pageController = PageController(initialPage: initPage);

  late Future<GetStorage> _cacheStorageFuture;
  DateTime get currentDate => _currentDate.value;

  set currentDate(value) => _currentDate.value = value;

  Future<void> clearCache() async {
    _sessionRevision.value++;
    var box = await _cacheStorageFuture;
    await box.erase();
  }

  List<CalendarEvent> deviceCalEvents2CalendarEvents(
    List<dcp.Event> deviceCalEvents,
  ) {
    return deviceCalEvents.map((event) {
      final end = event.endDate;
      var correctedEnd = end;
      if (event.isAllDay &&
          end.hour == 0 &&
          end.minute == 0 &&
          !AppUtils.isSameDay(event.startDate, end)) {
        correctedEnd = end.subtract(Duration(minutes: 1));
      }
      return CalendarEvent(
        title: event.title,
        startDate: event.startDate,
        endDate: correctedEnd,
        color: AppColors.cal1,
        url: "$deviceEventScheme${event.eventId}",
      );
    }).toList();
  }

  List<CalendarEvent> events2CalendarEvents(List<Event> events) {
    List<Color> colors = [AppColors.cal3, AppColors.cal2, AppColors.cal1];
    final colorMap = {
      for (var i = 0; i < EventType.values.length; i++)
        EventType.values[i]: colors[i % colors.length],
    };

    return events.map((event) {
      final color = colorMap[event.eventType] ?? colors[0];
      final fallbackDate = DateTime.now();
      final startDate =
          event.startAt ??
          event.endAt ??
          event.recruitmentStartAt ??
          event.recruitmentEndAt ??
          fallbackDate;
      var endDate =
          event.endAt ??
          event.startAt ??
          event.recruitmentEndAt ??
          event.recruitmentStartAt ??
          startDate;
      if (endDate.isBefore(startDate)) {
        endDate = startDate;
      }

      return CalendarEvent(
        title: event.title,
        startDate: startDate,
        endDate: endDate,
        color: color,
        url: event.uri,
      );
    }).toList();
  }

  Stream<List<CalendarEvent>> getCalendarEvents(DateTime date) async* {
    final uid = _auth.currentUser?.uid;
    final revision = _sessionRevision.value;
    bool isCurrentSession() =>
        !isClosed &&
        _auth.currentUser?.uid == uid &&
        _sessionRevision.value == revision;
    List<dcp.Event> deviceEvents = [];

    final calService = Get.find<CalendarService>();
    final calPermission = await calService.checkPermission();
    if (!isCurrentSession()) return;
    if (calPermission &&
        Get.find<AppSettingsService>().includeDeviceEvents.value) {
      deviceEvents = await calService.retrieveEvents(
        AppUtils.startOfMonth(date),
        AppUtils.endOfMonth(date),
      );
    }

    if (!isCurrentSession()) return;
    if (uid == null) {
      yield mergeDuitEventsAndDeviceEvents([], deviceEvents);
      return;
    }

    final cacheKey =
        'uid:${Uri.encodeComponent(uid)}:${date.year}-${date.month}';
    try {
      var storage = await _cacheStorageFuture;
      if (!isCurrentSession()) return;
      var cache = storage.read(cacheKey) ?? [];
      var events = List<Event>.generate(
        cache.length,
        (i) => Event.fromJson(cache[i]),
      );

      yield mergeDuitEventsAndDeviceEvents(events, deviceEvents);
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }

    if (!isCurrentSession()) return;
    var apiClient = Get.find<ApiClient>();
    RequestResult<List<Event>> reqResult = await apiClient.getEventsForCalendar(
      year: date.year,
      month: date.month,
    );
    if (!isCurrentSession()) return;
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

    try {
      final storage = await _cacheStorageFuture;
      if (!isCurrentSession()) return;
      await storage.write(
        cacheKey,
        events.map((event) => event.toJson()).toList(),
      );
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    }

    if (!isCurrentSession()) return;
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
    var lastUid = _auth.currentUser?.uid;
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user?.uid == lastUid) return;
      lastUid = user?.uid;
      _sessionRevision.value++;
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    pageController.dispose();
    super.onClose();
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

  Future<GetStorage> _initStorage() async {
    await GetStorage.init(_cacheStorageName);
    final storage = GetStorage(_cacheStorageName);
    // Month-only entries from previous versions have no trustworthy owner.
    final legacyKeys = storage
        .getKeys<Iterable<String>>()
        .where((key) => !key.startsWith('uid:'))
        .toList();
    for (final key in legacyKeys) {
      await storage.remove(key);
    }
    return storage;
  }
}
