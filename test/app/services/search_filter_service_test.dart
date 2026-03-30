import 'dart:io';

import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
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

    await GetStorage.init(SearchFilterService.storageBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(SearchFilterService.storageBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('falls back to default filter when cached payload is not a map', () async {
    final box = GetStorage(SearchFilterService.storageBoxName);
    await box.write('filter', 'broken');

    expect(() => Get.put(SearchFilterService()), returnsNormally);

    final service = Get.find<SearchFilterService>();
    expect(service.filter.categories, isEmpty);
    expect(service.filter.host, isNull);
    expect(service.filter.showEnded, isTrue);
  });

  test('falls back to default filter when cached payload shape is invalid', () async {
    final box = GetStorage(SearchFilterService.storageBoxName);
    await box.write('filter', {
      'categories': 'wrong-type',
      'showEnded': true,
    });

    expect(() => Get.put(SearchFilterService()), returnsNormally);

    final service = Get.find<SearchFilterService>();
    expect(service.filter.categories, isEmpty);
    expect(service.filter.host, isNull);
    expect(service.filter.showEnded, isTrue);
  });
}
