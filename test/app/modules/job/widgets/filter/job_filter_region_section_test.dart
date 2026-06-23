import 'dart:io';

import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_region_section.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:flutter/material.dart';
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

  testWidgets('renders region row without all-label summary by default', (
    tester,
  ) async {
    Get.put(JobFilterService());
    Get.put(JobFilterViewController());

    await tester.pumpWidget(_buildSubject());

    expect(find.text('지역별'), findsOneWidget);
    expect(find.text('중복 선택 가능'), findsOneWidget);
    expect(find.text('전체'), findsNothing);

    final rowContainer = tester.widget<SizedBox>(
      find
          .ancestor(of: find.byType(Row), matching: find.byType(SizedBox))
          .first,
    );
    expect(rowContainer.height, 56);

    final chevron = tester.widget<Image>(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is AssetImage,
      ),
    );
    expect(chevron.width, 16);
    expect(chevron.height, 16);

    await tester.tap(find.text('지역별'));
    await tester.pumpAndSettle();

    expect(find.text('지역'), findsOneWidget);
    expect(find.text('지역 초기화'), findsOneWidget);
  });

  testWidgets('renders selected region summary in the row', (tester) async {
    await GetStorage(JobFilterService.storageBoxName).write(
      'filter',
      const JobFilter(
        workRegions: {
          WorkRegion.seoul,
          WorkRegion.gyeonggi,
          WorkRegion.incheon,
        },
      ).toJson(),
    );
    Get.put(JobFilterService());
    Get.put(JobFilterViewController());

    await tester.pumpWidget(_buildSubject());

    expect(find.text('서울 외 2건'), findsOneWidget);

    final summary = tester.widget<Text>(find.text('서울 외 2건'));
    expect(summary.style?.color, const Color(0xFFC63C33));
    expect(summary.style?.fontSize, 14);
    expect(summary.style?.fontWeight, FontWeight.w600);
  });

  testWidgets('anchors selected summary and chevron to the trailing edge', (
    tester,
  ) async {
    await GetStorage(JobFilterService.storageBoxName).write(
      'filter',
      const JobFilter(workRegions: {WorkRegion.incheon}).toJson(),
    );
    Get.put(JobFilterService());
    Get.put(JobFilterViewController());

    await tester.pumpWidget(_buildSubject());

    final summaryRect = tester.getRect(find.text('인천'));
    final chevronRect = tester.getRect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is AssetImage,
      ),
    );
    final scaffoldWidth = tester.getSize(find.byType(Scaffold)).width;

    expect(chevronRect.right, closeTo(scaffoldWidth - 16, 0.1));
    expect(chevronRect.left - summaryRect.right, closeTo(12, 0.1));
  });
}

Widget _buildSubject() {
  return const GetMaterialApp(
    home: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: JobFilterRegionSection(),
      ),
    ),
  );
}
