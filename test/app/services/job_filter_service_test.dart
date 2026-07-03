import 'dart:io';

import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
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

    await GetStorage.init(JobFilterService.storageBoxName);
  });

  setUp(() async {
    Get.reset();
    await GetStorage(JobFilterService.storageBoxName).erase();
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('normalizes unsupported cached job filter values', () async {
    final box = GetStorage(JobFilterService.storageBoxName);
    await box.write('filter', {
      'careerFilters': ['entry'],
      'workRegions': ['SEOUL', 'ETC'],
      'employmentTypes': ['FULL_TIME', 'PART_TIME', 'INTERN'],
      'showClosed': false,
    });

    Get.put(JobFilterService());

    final service = Get.find<JobFilterService>();
    expect(service.filter.careerFilters, {JobCareerFilter.entry});
    expect(service.filter.workRegions, {WorkRegion.seoul});
    expect(service.filter.employmentTypes, {JobEmploymentType.fullTime});
    expect(service.filter.showClosed, isFalse);
  });
}
