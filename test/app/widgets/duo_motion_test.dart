import 'package:duty_it/app/widgets/adaptive_paged_sliver.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

void main() {
  const bounds = Rect.fromLTWH(0, 0, 900, 800);
  const fold = Rect.fromLTRB(490, 0, 526, 800);

  testWidgets('fold geometry animates and can reverse without losing search', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final focus = FocusNode();
    final text = TextEditingController(text: '간호');
    addTearDown(focus.dispose);
    addTearDown(text.dispose);
    final state = PagingState<int, int>(
      pages: [
        [0, 1, 2, 3],
      ],
      keys: [1],
      hasNextPage: false,
    );
    Widget app(bool folded) => MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: DuoLayoutScope(
              data: DuoLayoutData(
                contentBounds: bounds,
                divisions: folded ? [fold] : [],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FoldSafeHeader(
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            key: const ValueKey('search'),
                            controller: text,
                            focusNode: focus,
                          ),
                        ),
                      ),
                    ),
                    AdaptivePagedSliver<int, int>(
                      state: state,
                      fetchNextPage: () => fail('folding must not fetch'),
                      builderDelegate: PagedChildBuilderDelegate<int>(
                        itemBuilder: (_, item, _) =>
                            SizedBox(key: ValueKey('card-$item'), height: 180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    focus.requestFocus();
    text.selection = const TextSelection.collapsed(offset: 1);
    await tester.pump();
    final element = tester.element(find.byKey(const ValueKey('search')));
    final initialX = tester.getTopLeft(find.byKey(const ValueKey('card-0'))).dx;
    final initialWidth = tester
        .getSize(find.byKey(const ValueKey('card-0')))
        .width;
    final initialHeader = tester
        .getSize(find.byKey(const ValueKey('search')))
        .width;
    await tester.pumpWidget(app(true));
    await tester.pump(const Duration(milliseconds: 160));
    final midX = tester.getTopLeft(find.byKey(const ValueKey('card-0'))).dx;
    final midWidth = tester.getSize(find.byKey(const ValueKey('card-0'))).width;
    expect(midX, greaterThan(initialX));
    expect(midX, lessThan(132));
    expect(midWidth, lessThan(initialWidth));
    expect(midWidth, greaterThan(358));
    expect(
      tester.getSize(find.byKey(const ValueKey('search'))).width,
      allOf(lessThan(initialHeader), greaterThan(458)),
    );
    expect(tester.element(find.byKey(const ValueKey('search'))), same(element));
    expect(focus.hasFocus, isTrue);
    expect(text.selection.baseOffset, 1);
    // Reverse before completion rather than waiting for the previous tween.
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('card-0'))).dx,
      closeTo(initialX, 0.1),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('card-0'))).width,
      closeTo(initialWidth, 0.1),
    );
    expect(focus.hasFocus, isTrue);
    expect(text.text, '간호');
    expect(tester.takeException(), isNull);
  });

  testWidgets('animated fold keeps a scrolled variable-height reading anchor', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final state = PagingState<int, int>(
      pages: [List.generate(100, (i) => i)],
      keys: [1],
      hasNextPage: false,
    );
    Widget app(bool folded, {bool narrowFold = false}) => MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: DuoLayoutScope(
              data: DuoLayoutData(
                contentBounds: bounds,
                divisions: folded
                    ? [
                        narrowFold
                            ? const Rect.fromLTRB(260, 0, 300, 800)
                            : fold,
                      ]
                    : [],
              ),
              child: DuoPostureTransition(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    controller: scroll,
                    slivers: [
                      AdaptivePagedSliver<int, int>(
                        state: state,
                        fetchNextPage: () {},
                        builderDelegate: PagedChildBuilderDelegate<int>(
                          itemBuilder: (_, item, _) => LayoutBuilder(
                            builder: (_, constraints) => SizedBox(
                              key: ValueKey('row-$item'),
                              height:
                                  constraints.maxWidth / 2 +
                                  (item.isEven ? 60 : 130),
                            ),
                          ),
                        ),
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
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    scroll.jumpTo(3200);
    await tester.pumpAndSettle();
    final visible = find
        .byWidgetPredicate(
          (w) =>
              w is SizedBox &&
              w.key is ValueKey<String> &&
              (w.key as ValueKey<String>).value.startsWith('row-'),
        )
        .evaluate()
        .where((e) {
          final box = e.renderObject as RenderBox;
          return box.localToGlobal(Offset.zero).dy + box.size.height > 0;
        });
    final key = visible.first.widget.key!;
    final before = tester.getTopLeft(find.byKey(key)).dy;
    await tester.pumpWidget(app(true));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(key)).dy, closeTo(before, 1));
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(key)).dy, closeTo(before, 1));
    await tester.pumpWidget(app(true, narrowFold: true));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(key)).dy, closeTo(before, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a column change never cancels an active user drag', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final state = PagingState<int, int>(
      pages: [List.generate(100, (i) => i)],
      keys: [1],
      hasNextPage: false,
    );
    Widget app(bool folded) => MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 900,
            child: DuoLayoutScope(
              data: DuoLayoutData(
                contentBounds: bounds,
                divisions: folded
                    ? [const Rect.fromLTRB(260, 0, 300, 800)]
                    : [],
              ),
              child: CustomScrollView(
                controller: scroll,
                slivers: [
                  AdaptivePagedSliver<int, int>(
                    state: state,
                    fetchNextPage: () {},
                    builderDelegate: PagedChildBuilderDelegate<int>(
                      itemBuilder: (_, item, _) =>
                          SizedBox(key: ValueKey(item), height: 220),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    scroll.jumpTo(2000);
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(const Offset(400, 400));
    await gesture.moveBy(const Offset(0, -100));
    await tester.pump(const Duration(milliseconds: 16));
    expect(scroll.position.isScrollingNotifier.value, isTrue);
    await tester.pumpWidget(app(true));
    await tester.pump(const Duration(milliseconds: 16));
    expect(scroll.position.isScrollingNotifier.value, isTrue);
    final before = scroll.offset;
    await gesture.moveBy(const Offset(0, -80));
    await tester.pump(const Duration(milliseconds: 16));
    expect(scroll.offset, greaterThan(before + 60));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'rapid posture reversal continues from the current visual state',
    (tester) async {
      Widget app(bool folded) => MaterialApp(
        home: DuoLayoutScope(
          data: DuoLayoutData(divisions: folded ? [fold] : []),
          child: const DuoPostureTransition(child: Text('기존 화면')),
        ),
      );
      final fading = find.descendant(
        of: find.byType(DuoPostureTransition),
        matching: find.byType(FadeTransition),
      );
      await tester.pumpWidget(app(false));
      await tester.pumpAndSettle();
      await tester.pumpWidget(app(true));
      await tester.pump(const Duration(milliseconds: 100));
      final before = tester.widget<FadeTransition>(fading).opacity.value;
      await tester.pumpWidget(app(false));
      expect(
        tester.widget<FadeTransition>(fading).opacity.value,
        closeTo(before, 0.001),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<FadeTransition>(fading).opacity.value, 1);
    },
  );

  testWidgets(
    'horizontal half-open and full-open both animate one live child',
    (tester) async {
      Widget app(bool folded) => MaterialApp(
        home: DuoLayoutScope(
          data: DuoLayoutData(
            divisions: folded ? [const Rect.fromLTWH(0, 400, 900, 20)] : [],
          ),
          child: const DuoPostureTransition(
            child: Text('기존 화면', key: ValueKey('live')),
          ),
        ),
      );
      await tester.pumpWidget(app(false));
      await tester.pumpAndSettle();
      final element = tester.element(find.byKey(const ValueKey('live')));
      final fading = find.descendant(
        of: find.byType(DuoPostureTransition),
        matching: find.byType(FadeTransition),
      );
      for (final folded in [true, false]) {
        await tester.pumpWidget(app(folded));
        expect(
          tester.widget<FadeTransition>(fading).opacity.value,
          closeTo(0.92, 0.001),
        );
        await tester.pump(const Duration(milliseconds: 160));
        expect(
          tester.widget<FadeTransition>(fading).opacity.value,
          allOf(greaterThan(0.92), lessThan(1)),
        );
        expect(find.byKey(const ValueKey('live')), findsOneWidget);
        expect(
          tester.element(find.byKey(const ValueKey('live'))),
          same(element),
        );
        await tester.pumpAndSettle();
        expect(tester.widget<FadeTransition>(fading).opacity.value, 1);
      }
    },
  );

  testWidgets('reduced motion snaps header and posture to the final layout', (
    tester,
  ) async {
    Widget app(bool folded) => MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: DuoLayoutScope(
          data: DuoLayoutData(
            contentBounds: bounds,
            divisions: folded ? [fold] : [],
          ),
          child: const DuoPostureTransition(
            child: SizedBox(
              width: 900,
              child: FoldSafeHeader(
                child: SizedBox(key: ValueKey('header'), height: 50),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(false));
    await tester.pumpAndSettle();
    await tester.pumpWidget(app(true));
    expect(tester.getSize(find.byKey(const ValueKey('header'))).width, 458);
    final fading = find.descendant(
      of: find.byType(DuoPostureTransition),
      matching: find.byType(FadeTransition),
    );
    expect(tester.widget<FadeTransition>(fading).opacity.value, 1);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
