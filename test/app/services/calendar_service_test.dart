import 'dart:io';
import 'package:device_calendar_plus/device_calendar_plus.dart';

import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../helpers/fake_device_calendar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return Directory.systemTemp.path;
          }
          return null;
        });

    await GetStorage.init(CalendarService.registeredEventsBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(CalendarService.registeredEventsBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('service methods can read storage immediately after registration', () {
    final service = Get.put(CalendarService());

    expect(() => service.isRegistered('event-1'), returnsNormally);
    expect(service.isRegistered('event-1'), isFalse);
    expect(service.getRegisteredEventId('event-1'), isNull);
  });

  test(
    'manual save uses the selected calendar and blocks duplicate writes',
    () async {
      final plugin = FakeDeviceCalendar();
      final service = CalendarService(plugin: plugin);
      Future<CalendarSaveResult> save() => service.addEvent(
        calendarId: 'work',
        title: '행사',
        id: '42',
        startDate: DateTime.utc(2026, 10, 1),
        endDate: DateTime.utc(2026, 10, 1, 1),
        description: 'https://www.dutyit.net/events/42',
      );

      final results = await Future.wait([save(), save()]);
      expect(plugin.createCalls, 1);
      expect(results.map((r) => r.created), [true, false]);
      expect(plugin.events.values.single.calendarId, 'work');
      expect(plugin.events.values.single.timeZone, 'Asia/Seoul');
      expect(service.revision.value, 1);

      plugin.events
          .clear(); // Deleted outside DuIt: allow the user to save again.
      expect((await save()).created, isTrue);
      expect(plugin.createCalls, 2);
    },
  );

  test('failed calendar write is not marked as saved', () async {
    final service = CalendarService(
      plugin: FakeDeviceCalendar()..failCreation = true,
    );
    await expectLater(
      service.addEvent(
        calendarId: 'personal',
        title: '행사',
        id: '42',
        startDate: DateTime.utc(2026, 10, 1),
        endDate: DateTime.utc(2026, 10, 1, 1),
      ),
      throwsStateError,
    );
    expect(service.isRegistered('42'), isFalse);
    expect(service.revision.value, 0);
  });

  test('calendar picker excludes read-only and hidden calendars', () async {
    final plugin = FakeDeviceCalendar()
      ..calendars = const [
        Calendar(id: 'holidays', name: '공휴일', readOnly: true),
        Calendar(id: 'hidden', name: '숨김', readOnly: false, hidden: true),
        Calendar(id: 'work', name: '업무', readOnly: false),
        Calendar(id: 'primary', name: '기본', readOnly: false, isPrimary: true),
      ];
    expect(
      (await CalendarService(
        plugin: plugin,
      ).getWritableCalendars()).map((c) => c.id),
      ['primary', 'work'],
    );
  });
}
