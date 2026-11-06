import 'dart:async';
import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/calendar/controllers/custom_calendar_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class _User extends Fake implements User {
  _User(this.uid);
  @override
  final String uid;
}

class _Auth extends Fake implements FirebaseAuth {
  final changes = StreamController<User?>.broadcast(sync: true);
  @override
  User? currentUser;
  void signInAs(String? uid) {
    currentUser = uid == null ? null : _User(uid);
    changes.add(currentUser);
  }

  @override
  Stream<User?> authStateChanges() => changes.stream;
}

class _Calendar extends CalendarService {
  @override
  Future<bool> checkPermission() async => false;
}

class _Api extends ApiClient {
  @override
  void onInit() {}

  Future<List<Event>> Function() load = () async => [];
  @override
  Future<RequestResult<List<Event>>> getEventsForCalendar({
    required int year,
    required int month,
    EventType? type,
  }) async => RequestSuccess(await load());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methodChannel = MethodChannel('plugins.flutter.io/path_provider');
  final directory = Directory.systemTemp.createTempSync('duit-calendar-test-');
  final month = DateTime(2026, 11);
  const aOnly = Event(id: 1, title: 'A 전용 행사');
  late _Auth auth;
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
    auth = _Auth()..signInAs('A');
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
        if (events.any((e) => e.title == aOnly.title) && !shown.isCompleted)
          shown.complete();
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
