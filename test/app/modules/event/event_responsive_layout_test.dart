import 'package:duty_it/app/modules/event/widgets/event_detail_layout.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const poster = SizedBox(key: ValueKey('poster'), height: 120);
  const information = Text('일정 안내', key: ValueKey('information'));
  const fold = Rect.fromLTWH(360, 0, 24, 600);

  testWidgets(
    'detail uses opposite panes and stacks in one pane at large text',
    (tester) async {
      Future<void> resize(double scale) => tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const DuoLayoutScope(
              data: DuoLayoutData(divisions: [fold]),
              child: EventDetailLayout(
                poster: poster,
                information: information,
                safeLeft: 0,
                actions: SizedBox(key: ValueKey('actions'), height: 48),
              ),
            ),
          ),
        ),
      );
      await resize(1);
      final p = find.byKey(poster.key!);
      final info = find.byKey(information.key!);
      expect(tester.getRect(p).right, lessThanOrEqualTo(fold.left));
      expect(tester.getRect(info).left, greaterThanOrEqualTo(fold.right));
      expect(
        tester.getRect(find.byKey(const ValueKey('actions'))).left,
        greaterThanOrEqualTo(fold.right),
      );
      await resize(3);
      expect(tester.getRect(p).left, greaterThanOrEqualTo(fold.right));
      expect(
        tester.getRect(info).top,
        greaterThanOrEqualTo(tester.getRect(p).bottom),
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final edge in ['left', 'right']) {
    testWidgets('detail footer spans the $edge side control inset', (
      tester,
    ) async {
      const actionsKey = ValueKey('actions');
      final insets = EdgeInsets.only(
        left: edge == 'left' ? 84 : 0,
        right: edge == 'right' ? 84 : 0,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQueryData(
              padding: insets.copyWith(bottom: 34),
              viewPadding: insets.copyWith(bottom: 34),
            ),
            child: DuoLayoutScope(
              data: DuoLayoutData(
                isDuo: true,
                verticalBarEdge: edge,
                divisions: const [fold],
              ),
              child: Builder(
                builder: (context) => MediaQuery.removePadding(
                  context: context,
                  removeLeft: true,
                  removeRight: true,
                  child: EventDetailLayout(
                    poster: poster,
                    information: information,
                    safeLeft: insets.left,
                    contentInsets: insets,
                    actions: const SizedBox(key: actionsKey, height: 48),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final footer = tester.getRect(find.byType(DecoratedBox));
      expect(footer.left, 0);
      expect(footer.right, 800);
      expect(footer.height, 116);
      final actions = tester.getRect(find.byKey(actionsKey));
      expect(actions.center.dy, closeTo(footer.center.dy, .01));
      expect(footer.bottom - actions.bottom, greaterThanOrEqualTo(34));
      expect(actions.left, greaterThanOrEqualTo(fold.right));
      expect(actions.right, 800 - insets.right - 20);
      expect(tester.getRect(find.byKey(poster.key!)).left, insets.left + 20);
      expect(
        tester.getRect(find.byKey(poster.key!)).right,
        lessThanOrEqualTo(fold.left),
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final duo in [false, true]) {
    for (final bottom in [0.0, 34.0]) {
      testWidgets('phone footer clearance (Duo $duo, bottom $bottom)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(466, 678);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const actionsKey = ValueKey('actions');
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(
                padding: EdgeInsets.only(bottom: bottom),
                viewPadding: EdgeInsets.only(bottom: bottom),
              ),
              child: DuoLayoutScope(
                data: DuoLayoutData(isDuo: duo),
                child: const EventDetailLayout(
                  poster: poster,
                  information: information,
                  safeLeft: 0,
                  actions: SizedBox(key: actionsKey, height: 48),
                ),
              ),
            ),
          ),
        );
        final footer = tester.getRect(find.byType(DecoratedBox));
        final actions = tester.getRect(find.byKey(actionsKey));
        final above = actions.top - footer.top;
        final below = footer.bottom - actions.bottom;
        expect(below, greaterThanOrEqualTo(bottom));
        if (duo) {
          expect(above, closeTo(below, .01));
        } else {
          // Ordinary phones retain their 12pt spacing plus home clearance.
          expect(above, 12);
          expect(below, 12 + bottom);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'event tiles keep two phone columns and clear an off-center hinge',
    (tester) async {
      late DuoGridGeometry grid;
      Future<void> measure(double width, List<Rect> folds) => tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: DuoLayoutScope(
            data: DuoLayoutData(
              contentBounds: Rect.fromLTWH(0, 0, width, 600),
              divisions: folds,
            ),
            child: Builder(
              builder: (context) {
                grid = DuoGridGeometry.forWidth(
                  context,
                  width - 32,
                  eventTiles: true,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      await measure(402, []);
      expect(grid.columns, 2);
      await measure(840, [fold]);
      expect(grid.columns, 4);
      final cell = (840 - 32 - grid.padding.horizontal - grid.spacing * 3) / 4;
      final secondEnd = 16 + grid.padding.left + cell * 2 + grid.spacing;
      expect(secondEnd, closeTo(fold.left, 0.01));
      expect(secondEnd + grid.spacing, closeTo(fold.right, 0.01));
    },
  );
}
