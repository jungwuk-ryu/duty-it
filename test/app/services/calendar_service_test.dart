import 'dart:io';

import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
}
