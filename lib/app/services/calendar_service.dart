import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CalendarService extends GetxService {
  static const String registeredEventsBoxName = "calendarServiceRegisteredEvents";
  late GetStorage _box;
  final _plugin = DeviceCalendar.instance;

  @override
  void onReady() {
    super.onReady();
    _box = GetStorage(registeredEventsBoxName);
  }

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
    var status = await _plugin.hasPermissions();

    if (! await checkPermission()) {
      await _plugin.requestPermissions();
    }

    return await checkPermission();
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

    if (_isRegistered(id)) return;

    String eventId = await _plugin.createEvent(
      calendarId: (await _getCalendar()).id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      description: description,
      timeZone: 'Asia/Seoul',
      availability: EventAvailability.busy,
    );

    await _registerEvent(id, eventId);

    await _plugin.showEventModal(eventId);
  }

  Future<void> removeEvent(String id) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print("웹에서는 캘린더 행사 삭제 요청을 건너뜁니다.");
      }
      return;
    }

    if (!_isRegistered(id)) return;

    String? eventId = _getRegisteredEventId(id);
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

    await _plugin.deleteEvent(eventId: eventId);
  }

  Future<Calendar> _getCalendar() async {
    final calendars = await _plugin.listCalendars();
    return calendars.firstWhere(
      (cal) => cal.isPrimary && !cal.readOnly,
      orElse: () => calendars.first,
    );
  }

  bool _isRegistered(String id) {
    return _box.read(id) != null;
  }

  Future<void> _registerEvent(String id, String eventId) async {
    await _box.write(id.toString(), eventId);
  }
  
  Future<void> _unregisterEvent(String id) async {
    await _box.remove(id.toString());
  }

  String? _getRegisteredEventId(String id) {
    return _box.read(id.toString());
  }
}
