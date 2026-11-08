import 'dart:ui' show SemanticsRole, Tristate;

import 'package:duty_it/app/modules/main/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> showBar(WidgetTester tester, List<int> calls) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (_, update) => MainTabBar(
              selectedIndex: selected,
              onSelected: (i) {
                calls.add(i);
                // A signed-out user is redirected when requesting bookmarks.
                if (i != 2) update(() => selected = i);
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tap, reselect, and refused tab match the active page', (
    tester,
  ) async {
    final calls = <int>[];
    await showBar(tester, calls);
    for (final label in ['채용', '채용', '북마크']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    expect(calls, [1, 1, 2]);
    final job = tester.getSemantics(find.text('채용')).getSemanticsData();
    expect(job.role, SemanticsRole.tab);
    expect(job.flagsCollection.isSelected, Tristate.isTrue);
    expect(
      tester
          .getSemantics(find.text('북마크'))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isFalse,
    );
    expect(
      tester.getCenter(find.byType(FractionallySizedBox)).dx,
      closeTo(tester.getCenter(find.text('채용')).dx, 1),
    );
  });

  testWidgets('drag previews a tab and commits only on release', (
    tester,
  ) async {
    final calls = <int>[];
    await showBar(tester, calls);
    final start = tester.getCenter(find.text('행사'));
    final end = tester.getCenter(find.text('캘린더'));
    for (final cancel in [true, false]) {
      final gesture = await tester.startGesture(start);
      await gesture.moveTo(tester.getCenter(find.text('채용')));
      await gesture.moveTo(end);
      await tester.pumpAndSettle();
      expect(calls, isEmpty);
      expect(
        tester.getCenter(find.byType(FractionallySizedBox)).dx,
        closeTo(end.dx, 1),
      );
      if (cancel) {
        await gesture.cancel();
        await tester.pumpAndSettle();
        expect(calls, isEmpty);
        expect(
          tester.getCenter(find.byType(FractionallySizedBox)).dx,
          closeTo(start.dx, 1),
        );
      } else {
        await gesture.up();
        await tester.pumpAndSettle();
        expect(calls, [3]);
      }
    }
  });
}
