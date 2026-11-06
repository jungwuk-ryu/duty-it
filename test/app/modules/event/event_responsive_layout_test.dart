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
