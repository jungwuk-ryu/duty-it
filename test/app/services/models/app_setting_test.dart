import 'dart:io';

import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  const boxName = 'appSettingTestBox';

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return Directory.systemTemp.path;
          }
          return null;
        });

    await GetStorage.init(boxName);
    await GetStorage.init(AppSettingsService.storageBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(boxName).erase();
    await GetStorage(AppSettingsService.storageBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('restores a stored value when the persisted type matches', () async {
    final box = GetStorage(boxName);
    await box.write('event_sorting_type', 'popular');

    final setting = AppSetting<String>(
      key: 'event_sorting_type',
      box: box,
      defaultValue: 'latest',
    );

    expect(setting.value, 'popular');
  });

  test(
    'falls back to default when the persisted type does not match',
    () async {
      final box = GetStorage(boxName);
      await box.write('include_device_events', 'true');

      final setting = AppSetting<bool>(
        key: 'include_device_events',
        box: box,
        defaultValue: false,
      );

      expect(setting.value, isFalse);
      expect(box.read('include_device_events'), isNull);
    },
  );

  test('does not include device calendar events by default', () {
    final service = Get.put(AppSettingsService());

    expect(service.includeDeviceEvents.value, isFalse);
  });

  test('keeps an explicitly stored device calendar choice', () async {
    await GetStorage(
      AppSettingsService.storageBoxName,
    ).write('include_device_events', true);

    final service = Get.put(AppSettingsService());

    expect(service.includeDeviceEvents.value, isTrue);
  });

  test('collects usage analytics until the user opts out', () async {
    expect(
      Get.put(AppSettingsService()).analyticsCollectionEnabled.value,
      isTrue,
    );

    Get.reset();
    await GetStorage(
      AppSettingsService.storageBoxName,
    ).write('analytics_collection_enabled', false);

    final service = Get.put(AppSettingsService());

    expect(service.analyticsCollectionEnabled.value, isFalse);
  });
}
