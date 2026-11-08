import 'dart:ui' show SemanticsRole, Tristate;

import 'package:duty_it/app/modules/main/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> showBar(
    WidgetTester tester,
    List<int> calls, {
    Axis axis = Axis.horizontal,
  }) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: Align(
            heightFactor: 1,
            child: SizedBox(
              width: axis == Axis.vertical ? 56 : double.infinity,
              child: StatefulBuilder(
                builder: (_, update) => MainTabBar(
                  axis: axis,
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

  testWidgets('vertical lens follows presses and returns after a refused tab', (
    tester,
  ) async {
    final calls = <int>[];
    await showBar(tester, calls, axis: Axis.vertical);
    double tabY(String label) => tester
        .getCenter(
          find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
        )
        .dy;
    double lensY() => tester.getCenter(find.byType(FractionallySizedBox)).dy;

    await tester.tap(find.text('채용'));
    await tester.pumpAndSettle();
    expect(lensY(), closeTo(tabY('채용'), 1));
    final press = await tester.startGesture(tester.getCenter(find.text('캘린더')));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(lensY(), closeTo(tabY('캘린더'), 1));
    expect(calls, [1]);
    await press.cancel();
    await tester.pumpAndSettle();
    expect(lensY(), closeTo(tabY('채용'), 1));

    await tester.tap(find.text('북마크'));
    await tester.pumpAndSettle();
    expect(calls, [1, 2]);
    expect(lensY(), closeTo(tabY('채용'), 1));
    expect(
      tester.getSemantics(find.text('채용')).getSemanticsData().role,
      SemanticsRole.tab,
    );
    expect(
      tester
          .getSemantics(find.text('채용'))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    await tester.tap(find.text('캘린더'));
    await tester.pumpAndSettle();
    expect(calls, [1, 2, 3]);
    expect(lensY(), closeTo(tabY('캘린더'), 1));
  });

  testWidgets('large text rail scrolls in limited height without selecting', (
    tester,
  ) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final calls = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: SizedBox(
              width: 72,
              height: 160,
              child: SingleChildScrollView(
                controller: scroll,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 160),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        const Spacer(),
                        MainTabBar(
                          axis: Axis.vertical,
                          selectedIndex: 0,
                          onSelected: calls.add,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.text('행사'), const Offset(0, -220));
    await tester.pumpAndSettle();
    expect(scroll.offset, greaterThan(0));
    expect(calls, isEmpty);
    await tester.ensureVisible(find.text('캘린더'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('캘린더'));
    await tester.pumpAndSettle();
    expect(calls, [3]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vertical tabs fill the rail under loose width constraints', (
    tester,
  ) async {
    final calls = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 56,
            child: Column(
              children: [
                MainTabBar(
                  axis: Axis.vertical,
                  selectedIndex: 0,
                  onSelected: calls.add,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(MainTabBar)).width, 56);
    final tabs = find.byType(InkWell);
    for (var i = 0; i < mainTabs.length; i++) {
      expect(tester.getSize(tabs.at(i)).width, 48);
    }
    final calendar = tester.getRect(tabs.last);
    await tester.tapAt(Offset(calendar.left + 2, calendar.center.dy));
    await tester.pumpAndSettle();
    expect(calls, [3]);
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
