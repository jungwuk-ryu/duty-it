import 'dart:ui' show CheckedState, SemanticsAction;

import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/adaptive_filter_row.dart';
import 'package:flutter/services.dart';
import 'package:duty_it/app/widgets/sort_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'event menu anchors beneath trigger and immediately applies the spoken choice',
    (tester) async {
      final choices = <EventSortingType>[];
      var current = EventSortingType.latest;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topRight,
              child: StatefulBuilder(
                builder: (_, update) => SortMenu(
                  selected: current,
                  options: EventSortingType.values,
                  onSelected: (value) => update(() {
                    choices.add(value);
                    current = value;
                  }),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('최신순'));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byType(DuitGlass));
      final trigger = tester.getRect(find.byType(TextButton).first);
      expect(panel.top, greaterThanOrEqualTo(trigger.bottom));
      expect(panel.right, closeTo(trigger.right - 16, 1));
      final checked = tester.getSemantics(find.text('최신 등록순'));
      expect(checked.flagsCollection.isChecked, CheckedState.isTrue);
      final next = tester.getSemantics(find.text('모집 마감 임박순'));
      tester.binding.renderViews.single.owner!.semanticsOwner!.performAction(
        next.id,
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();
      expect(choices, [EventSortingType.closingSoon]);
      expect(find.text('모집 마감'), findsOneWidget);
      expect(find.byType(MenuItemButton), findsNothing);
      await tester.tap(find.text('모집 마감'));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.text('모집 마감 임박순')).flagsCollection.isChecked,
        CheckedState.isTrue,
      );
    },
  );

  testWidgets(
    'job menu closes on outside tap, back and current selection without applying',
    (tester) async {
      final choices = <JobSortingType>[];
      var outsideTaps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SortMenu(
                  selected: JobSortingType.latest,
                  options: JobSortingType.values,
                  onSelected: choices.add,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => outsideTaps++,
                  child: const Text('다른 동작'),
                ),
              ],
            ),
          ),
        ),
      );
      for (final close in ['outside', 'back', 'escape', 'reselect']) {
        await tester.tap(find.text('최신순'));
        await tester.pumpAndSettle();
        expect(find.text('급여순'), findsOneWidget);
        expect(find.text('인기순'), findsNothing);
        switch (close) {
          case 'outside':
            await tester.tap(find.text('다른 동작'));
          case 'escape':
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          case 'back':
            await tester.binding.handlePopRoute();
          default:
            await tester.tap(find.text('최신 등록순'));
        }
        await tester.pumpAndSettle();
        expect(find.byType(MenuItemButton), findsNothing);
      }
      expect(choices, isEmpty);
      expect(outsideTaps, 0);
    },
  );
  testWidgets(
    'wrapped sort control keeps the menu between the left rail and fold',
    (tester) async {
      const left = 72.0, fold = 475.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                textScaler: TextScaler.linear(2),
              ),
              child: DuoLayoutScope(
                data: const DuoLayoutData(
                  contentBounds: Rect.fromLTRB(left, 0, 800, 600),
                  divisions: [Rect.fromLTWH(fold, 0, 6, 600)],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: left + 16),
                  child: SizedBox(
                    width: fold - left - 32,
                    child: AdaptiveFilterRow(
                      children: [
                        const SizedBox(width: 310, height: 40),
                        SortMenu(
                          selected: EventSortingType.latest,
                          options: EventSortingType.values,
                          onSelected: (_) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final trigger = tester.getRect(find.byType(TextButton));
      expect(trigger.top, greaterThanOrEqualTo(40));
      await tester.tap(find.text('최신순'));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byType(DuitGlass));
      expect(panel.left, greaterThanOrEqualTo(left + 16));
      expect(panel.right, lessThanOrEqualTo(fold - 16));
      expect(tester.takeException(), isNull);
    },
  );
}
