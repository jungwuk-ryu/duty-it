import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shared search clears immediately without dismissing the keyboard',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 328,
                child: HomeSearchBar(controller: controller, filled: true),
              ),
            ),
          ),
        ),
      );
      expect(find.byTooltip('검색어 지우기'), findsNothing);
      await tester.enterText(find.byType(TextField), 'VITAL');
      await tester.pump();
      final clear = find.byTooltip('검색어 지우기');
      expect(clear, findsOneWidget);
      expect(tester.getSize(clear), const Size(48, 48));
      await tester.tap(clear);
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(find.byTooltip('검색어 지우기'), findsNothing);
      // External resets use the same update path as typed changes.
      controller.text = '외부 검색어';
      await tester.pump();
      expect(find.byTooltip('검색어 지우기'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('category controls have a 48dp target and selection semantics', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CategoryTag(
              name: '필터',
              isSelected: true,
              onTap: () => taps++,
            ),
          ),
        ),
      ),
    );
    final tag = find.byType(CategoryTag);
    expect(tester.getSize(tag).height, greaterThanOrEqualTo(48));
    final rect = tester.getRect(tag);
    await tester.tapAt(Offset(rect.center.dx, rect.top + 2));
    expect(taps, 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('필터')),
      matchesSemantics(
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
        label: '필터',
      ),
    );
  });
}
