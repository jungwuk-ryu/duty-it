import 'package:device_calendar_plus/device_calendar_plus.dart';

class FakeDeviceCalendar implements DeviceCalendar {
  List<Calendar> calendars = const [
    Calendar(id: 'personal', name: '개인 캘린더', readOnly: false, isPrimary: true),
  ];
  final Map<String, Event> events = {};
  int createCalls = 0;
  bool failCreation = false;
  CalendarPermissionStatus permission = CalendarPermissionStatus.granted;

  @override
  Future<CalendarPermissionStatus> hasPermissions() async => permission;

  @override
  Future<CalendarPermissionStatus> requestPermissions() async => permission;

  @override
  Future<List<Calendar>> listCalendars() async => calendars;

  @override
  Future<Event?> getEvent(String id) async => events[id];

  @override
  Future<String> createEvent({
    required String calendarId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    bool isAllDay = false,
    String? description,
    String? location,
    String? timeZone,
    EventAvailability availability = EventAvailability.busy,
  }) async {
    createCalls++;
    if (failCreation) throw StateError('write failed');
    final id = 'saved-$createCalls';
    events[id] = Event(
      eventId: id,
      instanceId: id,
      calendarId: calendarId,
      title: title,
      startDate: startDate,
      endDate: endDate,
      description: description,
      timeZone: timeZone,
      isAllDay: isAllDay,
      availability: availability,
      status: EventStatus.confirmed,
      isRecurring: false,
    );
    return id;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
