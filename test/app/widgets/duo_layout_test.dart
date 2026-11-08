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
