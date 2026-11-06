import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/filter/job_filter_region_section.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('renders region row without all-label summary by default', (
    tester,
  ) async {
    _registerController();

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
    _registerController({
      WorkRegion.seoul,
      WorkRegion.gyeonggi,
      WorkRegion.incheon,
    });

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
    _registerController({WorkRegion.incheon});

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

// These layout tests exercise the real filter state without starting disk
// persistence. The service tests cover reading and normalizing saved filters.
class _RegionController extends JobFilterViewController {
  @override
  final service = JobFilterService();
}

void _registerController([Set<WorkRegion> regions = const {}]) {
  final controller = _RegionController();
  controller.service.updateFilter(JobFilter(workRegions: regions));
  Get.put<JobFilterViewController>(controller);
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
