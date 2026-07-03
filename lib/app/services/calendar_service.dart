import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CalendarService extends GetxService {
  static const String registeredEventsBoxName = "calendarServiceRegisteredEvents";
  final GetStorage _box = GetStorage(registeredEventsBoxName);
  final _plugin = DeviceCalendar.instance;

  Future<bool> checkPermission() async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 권한 체크를 건너뜁니다.");
      }
      return true;
    }
    var status = await _plugin.hasPermissions();
    return status == CalendarPermissionStatus.granted;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 권한 요청을 건너뜁니다.");
      }
      return true;
    }

    bool hasPermission = await checkPermission();
    if (!hasPermission) {
      hasPermission = await _plugin.requestPermissions() == CalendarPermissionStatus.granted;
    }

    return hasPermission;
  }

  Future<void> addEvent({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required String id,
    String? description,
  }) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 행사 추가 요청을 건너뜁니다.");
      }
      return;
    }

    if (isRegistered(id)) return;
    Calendar? calendar = await _getCalendar();
    if (calendar == null) {
      if (kDebugMode) {
        print("캘린더를 불러오지 못해 행사를 추가할 수 없습니다.");
      }
      return;
    }

    String eventId = await _plugin.createEvent(
      calendarId: calendar.id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      description: description,
      timeZone: 'Asia/Seoul',
      availability: EventAvailability.busy,
    );

    await _registerEvent(id, eventId);
    await showEventModal(eventId);
  }

  Future<void> showEventModal(String eventId) async {
    await _plugin.showEventModal(eventId);
  }

  Future<void> removeEvent(String id) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 행사 삭제 요청을 건너뜁니다.");
      }
      return;
    }

    if (!isRegistered(id)) return;

    String? eventId = getRegisteredEventId(id);
    if (eventId != null) {
      await removeEventByEventId(eventId);
    }

    await _unregisterEvent(id);
  }

  Future<void> removeEventByEventId(String eventId) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 행사 삭제 요청을 건너뜁니다.");
      }
      return;
    }

    try {
      Event? event = await _plugin.getEvent(eventId);
      if (event != null) await _plugin.deleteEvent(eventId: eventId);
    } catch (e, st) {
      if (kDebugMode) {
        print("캘린더 행사 삭제 중 오류 발생: $e\n$st");
      }

      FirebaseCrashlytics.instance.recordError(e, st, reason: "캘린더 행사 삭제 중 오류 발생");
    }
  }

  Future<List<Event>> retrieveEvents(DateTime start, DateTime end) async {
    if (kIsWeb) {
      return [];
    }

    return await _plugin.listEvents(start, end);
  }
  
  String? getRegisteredEventId(String id) {
    return _box.read(id);
  }

  bool isRegistered(String id) {
    return _box.read(id) != null;
  }

  Future<Calendar?> _getCalendar() async {
    final calendars = await _plugin.listCalendars();

    try {
      var found = calendars.where(
        (cal) => cal.isPrimary && !cal.readOnly,
      );
      if (found.isNotEmpty) {
        return found.first;
      }

      found = calendars.where(
        (cal) => !cal.readOnly,
      );
      if (found.isNotEmpty) {
        return found.first;
      }

      return null;
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(
        e,
        null,
        reason: "캘린더를 불러오는 중 오류 발생",
      );
      return null;
    }
  }

  Future<void> _registerEvent(String id, String eventId) async {
    await _box.write(id, eventId);
  }
  
  Future<void> _unregisterEvent(String id) async {
    await _box.remove(id);
  }
}
