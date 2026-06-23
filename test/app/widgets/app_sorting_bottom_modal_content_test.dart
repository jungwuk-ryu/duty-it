import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/app_sorting_bottom_modal_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('matches the Figma sort modal spacing for event sorting', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: AppSortingBottomModalContent<String>(
                selectedType: '최신 등록순',
                types: const ['최신 등록순', '행사 날짜 임박순', '모집 마감 임박순', '인기순'],
                displayNameOf: (type) => type,
                onApply: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    final modalFinder = find.byType(AppSortingBottomModalContent<String>);
    final modalLeft = tester.getTopLeft(modalFinder).dx;
    final modalTop = tester.getTopLeft(modalFinder).dy;

    expect(tester.getSize(modalFinder), const Size(360, 376));
    expect(tester.getTopLeft(find.text('정렬')).dy - modalTop, 24);
    expect(tester.getTopLeft(find.text('최신 등록순')).dx - modalLeft, 16);
    expect(tester.getTopLeft(find.text('최신 등록순')).dy - modalTop, 75);
    expect(tester.getTopLeft(find.byType(AppNormalButton)).dx - modalLeft, 16);
    expect(tester.getTopLeft(find.byType(AppNormalButton)).dy - modalTop, 312);
    expect(tester.getSize(find.byType(AppNormalButton)), const Size(328, 48));
  });

  testWidgets('adds bottom safe area while preserving Figma minimum spacing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(bottom: 34)),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: AppSortingBottomModalContent<String>(
                  selectedType: '최신 등록순',
                  types: ['최신 등록순', '행사 날짜 임박순', '모집 마감 임박순', '인기순'],
                  displayNameOf: _displayString,
                  onApply: _ignoreString,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final modalFinder = find.byType(AppSortingBottomModalContent<String>);

    expect(tester.getSize(modalFinder), const Size(360, 394));
  });

  testWidgets('keeps selection local until apply is tapped', (tester) async {
    var appliedType = '최신 등록순';

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: AppSortingBottomModalContent<String>(
                selectedType: appliedType,
                types: const ['최신 등록순', '행사 날짜 임박순', '모집 마감 임박순', '인기순'],
                displayNameOf: (type) => type,
                onApply: (type) => appliedType = type,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('인기순'));
    await tester.pump();

    expect(appliedType, '최신 등록순');

    await tester.tap(find.text('정렬 적용'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(appliedType, '인기순');
  });
}

String _displayString(String value) => value;

void _ignoreString(String value) {}
