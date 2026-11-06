import 'dart:async';
import 'dart:io';

import 'package:device_calendar_plus/device_calendar_plus.dart' as dcp;
import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../helpers/fake_firebase_auth.dart';

class _Calendar extends CalendarService {
  bool granted = false;
  final queries = <(DateTime, DateTime)>[];

  @override
  Future<bool> checkPermission() async => granted;

  @override
  Future<List<dcp.Event>> retrieveEvents(DateTime start, DateTime end) async {
    queries.add((start, end));
    return [];
  }
}

class _Api extends ApiClient {
  @override
  void onInit() {}

  final requests = <(int, int)>[];
  Future<List<Event>> Function() load = () async => [];
  @override
  Future<RequestResult<List<Event>>> getEventsForCalendar({
    required int year,
    required int month,
    EventType? type,
  }) async {
    requests.add((year, month));
    return RequestSuccess(await load());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methodChannel = MethodChannel('plugins.flutter.io/path_provider');
  final directory = Directory.systemTemp.createTempSync('duit-calendar-test-');
  final month = DateTime(2026, 11);
  const aOnly = Event(id: 1, title: 'A 전용 행사');
  late FakeFirebaseAuth auth;
  late _Api api;

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (_) async => directory.path);
    for (final name in [
      CalendarService.registeredEventsBoxName,
      AppSettingsService.storageBoxName,
      'calendarCache',
    ]) {
      await GetStorage.init(name);
    }
  });

  setUp(() async {
    await GetStorage('calendarCache').erase();
    auth = FakeFirebaseAuth()..signInAs('A');
    Get.put(AppSettingsService());
    Get.put<CalendarService>(_Calendar());
    api = _Api();
    Get.put<ApiClient>(api);
  });

  tearDown(() async {
    Get.reset();
    await auth.changes.close();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  test(
    'swiping from January 31 opens February and includes its final day',
    () async {
      final calendar = Get.put(
        CalendarViewController(auth: auth, initialDate: DateTime(2027, 1, 31)),
      );
      final february = calendar.monthForPage(
        CalendarViewController.initPage + 1,
      );
      expect(february, DateTime(2027, 2));
      final device = Get.find<CalendarService>() as _Calendar;
      device.granted = true;
      await calendar.getCalendarEvents(february).drain<void>();
      expect(device.queries.single, (DateTime(2027, 2), DateTime(2027, 3)));
      expect(api.requests.single, (2027, 2));
    },
  );

  test(
    'the same month next year loads that page even after selecting a spillover day',
    () async {
      Get.put(CalendarViewController(auth: auth));
      final today = DateTime.now();
      final month = DateTime(today.year + 1, today.month);
      final page = CustomCalendarController(month);
      expect(page.currentDateTime, month);
      page.currentDateTime = month.subtract(const Duration(days: 1));
      final loaded = Completer<void>();
      api.load = () async {
        loaded.complete();
        return [];
      };
      page.init();
      addTearDown(page.dispose);
      await loaded.future;
      expect(api.requests.single, (month.year, month.month));
    },
  );

  test(
    'bookmarked events near midnight appear on their Seoul calendar day',
    () {
      final calendar = Get.put(CalendarViewController(auth: auth));
      final page = CustomCalendarController(month);
      final event = Event.fromJson({
        'id': 3,
        'startAt': '2026-11-07T00:30:00+09:00',
        'endAt': '2026-11-07T12:00:00',
      });
      page.events = calendar.events2CalendarEvents([event]);
      expect(page.getEventsByDay(DateTime(2026, 11, 6)), isEmpty);
      final shown = page.getEventsByDay(DateTime(2026, 11, 7)).single;
      expect(shown.startDate.hour, 0);
      expect(shown.startDate.minute, 30);
      expect(shown.endDate.hour, 12);
      expect(page.getEventsByDay(DateTime(2026, 11, 8)), isEmpty);
    },
  );

  test(
    'only the cache owner sees their bookmarks, even before logout cleanup',
    () async {
      final box = GetStorage('calendarCache');
      await box.write('2026-11', [aOnly.toJson()]);
      final calendar = Get.put(CalendarViewController(auth: auth));
      api.load = () async => [aOnly];
      final initial = await calendar.getCalendarEvents(month).toList();
      expect(initial.first, isEmpty);
      expect(box.hasData('2026-11'), isFalse);
      final cached = await calendar.getCalendarEvents(month).first;
      expect(cached.single.title, aOnly.title);

      auth.signInAs('B');
      api.load = () async => [];
      final next = await calendar.getCalendarEvents(month).toList();
      expect(next, everyElement(isEmpty));
    },
  );

  test(
    'a request from before logout cannot repopulate a cleared calendar',
    () async {
      final calendar = Get.put(CalendarViewController(auth: auth));
      final started = Completer<void>();
      final reply = Completer<List<Event>>();
      api.load = () {
        started.complete();
        return reply.future;
      };
      final loading = calendar.getCalendarEvents(month).toList();
      await started.future;
      auth.signInAs(null);
      await calendar.clearCache();
      auth.signInAs('A');
      reply.complete([aOnly]);
      expect(await loading, everyElement(isEmpty));
      expect(GetStorage('calendarCache').getKeys<Iterable<String>>(), isEmpty);
    },
  );

  test(
    'an open calendar clears the previous account while the new account loads',
    () async {
      Get.put(CalendarViewController(auth: auth));
      api.load = () async => [aOnly];
      final page = CustomCalendarController(month);
      final shown = Completer<void>();
      final listener = page.events.listen((events) {
        if (events.any((e) => e.title == aOnly.title) && !shown.isCompleted) {
          shown.complete();
        }
      });
      page.init();
      addTearDown(page.dispose);
      addTearDown(listener.cancel);
      await shown.future;

      final started = Completer<void>();
      final reply = Completer<List<Event>>();
      api.load = () {
        started.complete();
        return reply.future;
      };
      auth.signInAs('B');
      await started.future;
      expect(page.events, isEmpty);
      reply.complete([]);
    },
  );
}
