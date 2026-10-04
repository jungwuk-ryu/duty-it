import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:synchronized/synchronized.dart';

class CalendarSaveResult {
  final String eventId;
  final bool created;

  const CalendarSaveResult(this.eventId, {required this.created});
}

class CalendarService extends GetxService {
  static const String registeredEventsBoxName =
      'calendarServiceRegisteredEvents';
  final GetStorage _box = GetStorage(registeredEventsBoxName);
  final DeviceCalendar _plugin;
  final Lock _saveLock = Lock();
  final RxInt revision = 0.obs;

  CalendarService({DeviceCalendar? plugin})
    : _plugin = plugin ?? DeviceCalendar.instance;

  Future<bool> checkPermission() async {
    if (kIsWeb) return false;
    return await _plugin.hasPermissions() == CalendarPermissionStatus.granted;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (await checkPermission()) return true;
    return await _plugin.requestPermissions() ==
        CalendarPermissionStatus.granted;
  }

  Future<List<Calendar>> getWritableCalendars() async {
    final calendars = (await _plugin.listCalendars())
        .where((calendar) => !calendar.readOnly && !calendar.hidden)
        .toList();
    calendars.sort((a, b) {
      if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    return calendars;
  }

  Future<String> createLocalCalendar() =>
      _plugin.createCalendar(name: '듀잇', colorHex: '#C63C33');

  Future<String?> findRegisteredEventId(String id) async {
    final eventId = getRegisteredEventId(id);
    if (eventId == null) return null;
    try {
      if (await _plugin.getEvent(eventId) != null) return eventId;
    } on DeviceCalendarException catch (error) {
      if (error.errorCode != DeviceCalendarError.notFound) rethrow;
    }
    // The user may have removed the saved event in their calendar app.
    await _box.remove(id);
    return null;
  }

  Future<CalendarSaveResult> addEvent({
    required String calendarId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required String id,
    String? description,
  }) => _saveLock.synchronized(() async {
    final existing = await findRegisteredEventId(id);
    if (existing != null) return CalendarSaveResult(existing, created: false);

    final eventId = await _plugin.createEvent(
      calendarId: calendarId,
      title: title,
      startDate: startDate,
      endDate: endDate,
      description: description,
      timeZone: 'Asia/Seoul',
      availability: EventAvailability.busy,
    );
    if (eventId.isEmpty) {
      throw StateError('Calendar did not return an event ID');
    }
    await _box.write(id, eventId);
    revision.value++;
    return CalendarSaveResult(eventId, created: true);
  });

  Future<void> showEventModal(String eventId) =>
      _plugin.showEventModal(eventId);

  Future<List<Event>> retrieveEvents(DateTime start, DateTime end) async {
    if (kIsWeb) return [];
    return _plugin.listEvents(start, end);
  }

  String? getRegisteredEventId(String id) => _box.read<String>(id);

  bool isRegistered(String id) => getRegisteredEventId(id) != null;
}
