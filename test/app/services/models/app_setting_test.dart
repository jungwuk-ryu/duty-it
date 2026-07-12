import 'dart:io';

import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  setUp(() async {
    await GetStorage(boxName).erase();
  });

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

  test('falls back to default when the persisted type does not match', () async {
    final box = GetStorage(boxName);
    await box.write('include_device_events', 'true');

    final setting = AppSetting<bool>(
      key: 'include_device_events',
      box: box,
      defaultValue: true,
    );

    expect(setting.value, isTrue);
    expect(box.read('include_device_events'), isNull);
  });
}
