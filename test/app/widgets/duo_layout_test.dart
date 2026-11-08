import 'dart:ui' as ui;

import 'package:duty_it/app/widgets/adaptive_paged_sliver.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/adaptive_filter_row.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

void main() {
  for (final edge in ['left', 'right']) {
    test(
      'UIKit margins preserve the $edge rail and existing bottom safe area',
      () {
        final safe = EdgeInsets.only(
          left: edge == 'left' ? 84 : 0,
          right: edge == 'right' ? 84 : 0,
          bottom: 34,
        );
        final layout = DuoLayoutData(
          isDuo: true,
          verticalBarEdge: edge,
          layoutMargins: safe.copyWith(
            left: edge == 'left' ? 84 : 20,
            right: edge == 'right' ? 84 : 20,
          ),
        );
        final result = layout.foregroundPadding(
          MediaQueryData(padding: safe, viewPadding: safe),
        );
        expect(result.left, edge == 'left' ? 84 : 4);
        expect(result.right, edge == 'right' ? 84 : 4);
        expect(result.top + 8, 20);
        expect(result.bottom, 34);
        expect(
          layout
              .withContentBounds(const Rect.fromLTWH(0, 0, 100, 100))
              .layoutMargins,
          layout.layoutMargins,
        );
      },
    );
  }

  test(
    'standard phones, top safe areas, and keyboard insets are preserved',
    () {
      const media = MediaQueryData(
        padding: EdgeInsets.only(top: 62),
        viewPadding: EdgeInsets.only(top: 62, bottom: 34),
        viewInsets: EdgeInsets.only(bottom: 300),
      );
      expect(const DuoLayoutData().foregroundPadding(media), media.padding);
      const closed = DuoLayoutData(
        isDuo: true,
        layoutMargins: EdgeInsets.fromLTRB(20, 62, 20, 34),
      );
      final padding = closed.foregroundPadding(media);
      expect(padding.top, 62);
      expect(padding.bottom, 0);
    },
  );

  test('side toolbar geometry ignores obstructions on the opposite edge', () {
    const media = MediaQueryData(
      size: Size(1000, 700),
      padding: EdgeInsets.only(top: 24),
      viewPadding: EdgeInsets.only(right: 84),
    );
    const layout = DuoLayoutData(
      isDuo: true,
      verticalBarEdge: 'right',
      obstructions: [
        Rect.fromLTWH(920, 0, 80, 180),
        Rect.fromLTWH(0, 0, 100, 260),
      ],
    );
    expect(layout.sideBarWidth(media), 84);
    expect(layout.sideControlsTop(media), 180);
    const left = DuoLayoutData(
      isDuo: true,
      verticalBarEdge: 'left',
      obstructions: [
        Rect.fromLTWH(920, 0, 80, 180),
        Rect.fromLTWH(0, 0, 100, 260),
      ],
    );
    expect(left.sideBarWidth(media), 72);
    expect(left.sideControlsTop(media), 260);
  });

  group('Android foldable orientation', () {
    late List<List<dynamic>> orientations;

    setUp(() {
      orientations = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemChrome.setPreferredOrientations') {
              orientations.add(List<dynamic>.from(call.arguments as List));
            }
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets(
      'unfolding unlocks a letterboxed app and folding restores portrait',
      (tester) async {
        tester.view.devicePixelRatio = 2;
        tester.view.physicalSize = const Size(800, 1800);
        tester.view.display.size = const Size(800, 1800);
        addTearDown(tester.view.reset);
        addTearDown(tester.view.display.reset);
        await tester.pumpWidget(
          const MaterialApp(home: DuoLayout(child: SizedBox())),
        );
        expect(orientations, isEmpty);

        // The full display grows before Android removes the portrait letterbox.
        tester.view.display.size = const Size(1800, 2200);
        await tester.pump();
        expect(orientations, [isEmpty]);

        // A narrow split window and keyboard do not change the physical display.
        tester.view.physicalSize = const Size(700, 1000);
        await tester.pump();
        expect(orientations, hasLength(1));
        tester.view.display.size = const Size(2200, 1800);
        await tester.pump();
        expect(orientations, hasLength(1));

        tester.view.display.size = const Size(800, 1800);
        await tester.pump();
        expect(orientations.last, [
          'DeviceOrientation.portraitUp',
          'DeviceOrientation.portraitDown',
        ]);
        await tester.pumpWidget(const SizedBox());
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );

    testWidgets('a fold on a narrow display preserves search focus and text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 2;
      tester.view.display.size = const Size(1000, 1800);
      addTearDown(tester.view.reset);
      addTearDown(tester.view.display.reset);
      final focus = FocusNode();
      final text = TextEditingController(text: '간호 세미나');
      addTearDown(focus.dispose);
      addTearDown(text.dispose);
      Widget app(List<ui.DisplayFeature> features) => MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(displayFeatures: features),
          child: DuoLayout(
            child: Material(
              child: TextField(controller: text, focusNode: focus),
            ),
          ),
        ),
      );
      await tester.pumpWidget(app([]));
      focus.requestFocus();
      text.selection = const TextSelection.collapsed(offset: 3);
      await tester.pump();
      await tester.pumpWidget(
        app([
          const ui.DisplayFeature(
            bounds: Rect.fromLTWH(250, 0, 0, 900),
            type: ui.DisplayFeatureType.fold,
            state: ui.DisplayFeatureState.postureHalfOpened,
          ),
        ]),
      );
      await tester.pump();
      expect(orientations, [isEmpty]);
      expect(focus.hasFocus, isTrue);
      expect(text.text, '간호 세미나');
      expect(text.selection.baseOffset, 3);
      await tester.pumpWidget(app([]));
      await tester.pump();
      expect(orientations.last, [
        'DeviceOrientation.portraitUp',
        'DeviceOrientation.portraitDown',
      ]);
      expect(focus.hasFocus, isTrue);
      await tester.pumpWidget(const SizedBox());
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });

  testWidgets('deep two-to-one reflow finds the same variable-height item', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final state = PagingState<int, int>(
      pages: [List.generate(400, (i) => i)],
      keys: [1],
      hasNextPage: false,
    );
    Widget app(double width) => MaterialApp(
      home: Center(
        child: SizedBox(
          width: width,
          child: CustomScrollView(
            controller: scroll,
            slivers: [
              AdaptivePagedSliver<int, int>(
                state: state,
                fetchNextPage: () {},
                builderDelegate: PagedChildBuilderDelegate<int>(
                  itemBuilder: (_, item, index) => LayoutBuilder(
                    builder: (_, constraints) => SizedBox(
                      key: ValueKey('deep-$item'),
                      height:
                          constraints.maxWidth / 2 + (item.isEven ? 60 : 130),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(1200));
    await tester.pumpAndSettle();
    scroll.jumpTo(30000);
    await tester.pumpAndSettle();
    final elements = find
        .byWidgetPredicate(
          (w) =>
              w is SizedBox &&
              w.key is ValueKey<String> &&
              (w.key as ValueKey<String>).value.startsWith('deep-'),
        )
        .evaluate()
        .where((e) {
          final box = e.renderObject as RenderBox;
          return box.localToGlobal(Offset.zero).dy + box.size.height > 0;
        })
        .toList();
    final target = elements.first.widget.key!;
    final before = tester.getTopLeft(find.byKey(target)).dy;
    await tester.pumpWidget(app(400));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(target)).dy, closeTo(before, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'existing filter chips wrap instead of overflowing at large text',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Center(
                child: SizedBox(
                  width: 260,
                  child: AdaptiveFilterRow(
                    children: [
                      CategoryTag(name: '전체', isSelected: true, onTap: () {}),
                      const SizedBox(width: 8),
                      CategoryTag(name: '필터', isSelected: false, onTap: () {}),
                      CategoryTag(
                        name: '마감임박순',
                        isSelected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.getTopLeft(find.text('마감임박순')).dy,
        greaterThan(tester.getTopLeft(find.text('전체')).dy),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('fold-only changes preserve search focus and selection', (
    tester,
  ) async {
    final focus = FocusNode();
    final text = TextEditingController(text: '간호 세미나');
    addTearDown(focus.dispose);
    addTearDown(text.dispose);
    Widget app(bool folded) => MaterialApp(
      home: DuoLayoutScope(
        data: DuoLayoutData(
          contentBounds: const Rect.fromLTRB(0, 0, 900, 600),
          divisions: folded ? [const Rect.fromLTRB(430, 0, 470, 600)] : [],
        ),
        child: FoldSafeHeader(
          child: Material(
            child: TextField(controller: text, focusNode: focus),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(false));
    focus.requestFocus();
    text.selection = const TextSelection.collapsed(offset: 3);
    await tester.pump();
    await tester.pumpWidget(app(true));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    expect(text.selection.baseOffset, 3);
    await tester.pumpWidget(app(false));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    expect(text.text, '간호 세미나');
  });

  testWidgets('resizing a scrolled feed keeps the reading anchor', (
    tester,
  ) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final state = PagingState<int, int>(
      pages: [List.generate(60, (i) => i)],
      keys: [1],
      hasNextPage: false,
    );
    Widget app(double width) => MaterialApp(
      home: Center(
        child: SizedBox(
          width: width,
          child: CustomScrollView(
            controller: scroll,
            slivers: [
              AdaptivePagedSliver<int, int>(
                state: state,
                fetchNextPage: () {},
                builderDelegate: PagedChildBuilderDelegate<int>(
                  itemBuilder: (_, item, index) => SizedBox(
                    key: ValueKey('row-$item'),
                    height: item.isEven ? 140 : 240,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(380));
    await tester.pumpAndSettle();
    scroll.jumpTo(2200);
    await tester.pumpAndSettle();
    final before = tester.getTopLeft(find.byKey(const ValueKey('row-11'))).dy;
    await tester.pumpWidget(app(760));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('row-11'))).dy,
      closeTo(before, 1),
    );
    expect(tester.takeException(), isNull);
  });

  for (final floating in [false, true]) {
    testWidgets(
      'resizing keeps the card visible below pinned filters (floating: $floating)',
      (tester) async {
        final scroll = ScrollController();
        addTearDown(scroll.dispose);
        final state = PagingState<int, int>(
          pages: [List.generate(60, (i) => i)],
          keys: [1],
          hasNextPage: false,
        );
        Widget app(double width) => MaterialApp(
          home: Center(
            child: SizedBox(
              width: width,
              child: CustomScrollView(
                controller: scroll,
                slivers: [
                  if (floating)
                    const SliverAppBar(
                      floating: true,
                      snap: true,
                      primary: false,
                      title: Text('듀잇'),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  const SliverAppBar(
                    pinned: true,
                    primary: false,
                    toolbarHeight: 180,
                    title: Text('검색 및 필터'),
                    flexibleSpace: SizedBox.expand(
                      key: ValueKey('pinned-filters-body'),
                    ),
                  ),
                  AdaptivePagedSliver<int, int>(
                    eventTiles: true,
                    state: state,
                    fetchNextPage: () => fail('resizing must not fetch'),
                    builderDelegate: PagedChildBuilderDelegate<int>(
                      itemBuilder: (_, item, index) => LayoutBuilder(
                        builder: (_, constraints) => SizedBox(
                          key: ValueKey('pinned-row-$item'),
                          height: constraints.maxWidth * .75 + 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpWidget(app(336));
        await tester.pumpAndSettle();
        scroll.jumpTo(floating ? 420 : 480);
        await tester.pumpAndSettle();
        if (floating) {
          await tester.drag(find.byType(CustomScrollView), const Offset(0, 54));
          await tester.pumpAndSettle();
          // This row is hidden by the floating bar plus the pinned filters,
          // although it extends past the pinned header's minimum extent alone.
          final hidden = find.byKey(const ValueKey('pinned-row-0'));
          expect(tester.getBottomLeft(hidden).dy, greaterThan(180));
          expect(
            tester.getBottomLeft(hidden).dy,
            lessThanOrEqualTo(
              tester
                  .getBottomLeft(
                    find.byKey(const ValueKey('pinned-filters-body')),
                  )
                  .dy,
            ),
          );
        }
        final visibleTop = tester
            .getBottomLeft(find.byKey(const ValueKey('pinned-filters-body')))
            .dy;
        final anchor = find.byKey(const ValueKey('pinned-row-2'));
        final before = tester.getTopLeft(anchor).dy;
        expect(before, lessThan(visibleTop));
        expect(tester.getBottomLeft(anchor).dy, greaterThan(visibleTop));
        await tester.pumpWidget(app(674));
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(anchor).dy, closeTo(before, 1));
        expect(tester.getBottomLeft(anchor).dy, greaterThan(visibleTop));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'existing children reflow without clipping variable height content',
    (tester) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      final state = PagingState<int, int>(
        pages: [
          [0, 1, 2, 3],
        ],
        keys: [1],
        hasNextPage: false,
      );
      Widget app(double width) => MaterialApp(
        home: Center(
          child: SizedBox(
            width: width,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                AdaptivePagedSliver<int, int>(
                  state: state,
                  fetchNextPage: () =>
                      fail('resizing must not fetch another page'),
                  builderDelegate: PagedChildBuilderDelegate<int>(
                    itemBuilder: (_, item, index) => SizedBox(
                      key: ValueKey(item),
                      height: item.isEven ? 140 : 240,
                      child: Text('item $item'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpWidget(app(760));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.byKey(const ValueKey(0))).dy,
        tester.getTopLeft(find.byKey(const ValueKey(1))).dy,
      );
      expect(tester.getSize(find.byKey(const ValueKey(1))).height, 240);
      await tester.pumpWidget(app(380));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.byKey(const ValueKey(1))).dy,
        greaterThan(tester.getTopLeft(find.byKey(const ValueKey(0))).dy),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'asymmetric side bar keeps both columns clear of the physical fold',
    (tester) async {
      late DuoGridGeometry grid;
      const bounds = Rect.fromLTRB(20, 0, 900, 600);
      const fold = Rect.fromLTRB(490, 0, 526, 600);
      await tester.pumpWidget(
        MaterialApp(
          home: DuoLayoutScope(
            data: const DuoLayoutData(
              isDuo: true,
              contentBounds: bounds,
              divisions: [fold],
            ),
            child: Builder(
              builder: (context) {
                grid = DuoGridGeometry.forWidth(context, bounds.width - 32);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(grid.columns, 2);
      final usable = bounds.width - 32 - grid.padding.horizontal;
      final cell = (usable - grid.spacing) / 2;
      final leftEnd = bounds.left + 16 + grid.padding.left + cell;
      expect(leftEnd, closeTo(fold.left, 0.01));
      expect(leftEnd + grid.spacing, closeTo(fold.right, 0.01));
    },
  );

  testWidgets('search header and scaled text remain within a usable region', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: DuoLayoutScope(
            data: const DuoLayoutData(
              contentBounds: Rect.fromLTRB(0, 0, 900, 600),
              divisions: [Rect.fromLTRB(430, 0, 470, 600)],
            ),
            child: const FoldSafeHeader(
              child: SizedBox(key: ValueKey('search'), height: 40),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getTopRight(find.byKey(const ValueKey('search'))).dx,
      lessThan(430),
    );
    expect(tester.takeException(), isNull);
  });
}
