import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/widgets/adaptive_paged_sliver.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/event_tile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets('$platform opaque fallback preserves controls and semantics', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: platform),
          home: MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: DuoLayoutScope(
              data: const DuoLayoutData(reduceTransparency: true),
              child: Scaffold(
                body: DuitGlass(
                  child: TextButton(
                    onPressed: () => taps++,
                    child: const Text('메뉴'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(LiquidGlass), findsNothing);
      await tester.tap(find.text('메뉴'));
      expect(taps, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('event bookmarks stay independent without backdrop copies', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final toggled = <int>[];
    final events = [const Event(id: 1), const Event(id: 2, isBookmarked: true)];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AdaptivePagedSliver<int, Event>(
                eventTiles: true,
                state: PagingState(
                  pages: [events],
                  keys: [0],
                  hasNextPage: false,
                ),
                fetchNextPage: () {},
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (_, event, _) => EventTile(
                    event: event,
                    onTap: () {},
                    onBookmarkTap: () => toggled.add(event.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FakeGlass), findsNWidgets(2));
    expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
    await tester.tap(find.byTooltip('북마크 저장'));
    await tester.tap(find.byTooltip('북마크 해제'));
    expect(toggled, [1, 2]);
    expect(tester.takeException(), isNull);
  });
}
