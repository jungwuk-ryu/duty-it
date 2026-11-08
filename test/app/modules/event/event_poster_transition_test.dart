import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_event_card.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/event_poster_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

const _url = 'https://example.invalid/event.png';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> cachePoster(WidgetTester tester) async {
    await tester.runAsync(() async {
      final bytes = await rootBundle.load('assets/icons/paper.png');
      final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      codec.dispose();
      tester.binding.imageCache.putIfAbsent(
        const CachedNetworkImageProvider(_url),
        () => OneFrameImageStreamCompleter(
          Future.value(ImageInfo(image: frame.image)),
        ),
      );
    });
    addTearDown(() => tester.binding.imageCache.clear());
  }

  for (final duo in [false, true]) {
    testWidgets('detail poster flies into the viewer and back (Duo $duo)', (
      tester,
    ) async {
      tester.view.physicalSize = duo
          ? const Size(1000, 700)
          : const Size(402, 874);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final pixels = (await tester.runAsync(
        () => createTestImage(width: 600, height: 900),
      ))!;
      tester.binding.imageCache.putIfAbsent(
        const CachedNetworkImageProvider(_url),
        () => OneFrameImageStreamCompleter(
          Future.value(ImageInfo(image: pixels)),
        ),
      );
      addTearDown(tester.binding.imageCache.clear);
      const tag = 'detail-poster';
      await tester.pumpWidget(
        MaterialApp(
          builder: (_, child) => DuoLayoutScope(
            data: DuoLayoutData(
              isDuo: duo,
              divisions: duo
                  ? const [Rect.fromLTWH(480, 0, 24, 700)]
                  : const [],
            ),
            child: child!,
          ),
          home: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 180,
                  width: 260,
                  height: 195,
                  child: Builder(
                    builder: (source) => InkWell(
                      onTap: () => EventPosterViewer.show(
                        source,
                        image: const CachedNetworkImageProvider(_url),
                        title: '행사',
                        host: '주최',
                        heroTag: tag,
                      ),
                      child: const EventPosterImage(
                        imageUrl: _url,
                        heroTag: tag,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final source = tester.getRect(find.byType(Hero));
      await tester.tap(find.byType(EventPosterImage));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final flightImage = find
          .byWidgetPredicate(
            (widget) =>
                widget is Image &&
                widget.image == const CachedNetworkImageProvider(_url),
          )
          .last;
      final outward = tester.getRect(flightImage);
      expect(outward.width, greaterThan(source.width));
      await tester.pumpAndSettle();
      final target = tester.getRect(
        find.descendant(
          of: find.byType(EventPosterViewer),
          matching: find.byType(Hero),
        ),
      );
      expect(outward.width, lessThan(target.width));
      if (duo) expect(target.right, lessThanOrEqualTo(480));

      await tester.tap(find.byTooltip('닫기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final inward = tester.getRect(flightImage);
      expect(inward.width, greaterThan(source.width));
      expect(inward.width, lessThan(target.width));
      await tester.pumpAndSettle();
      expect(find.byType(EventPosterViewer), findsNothing);
      expect(tester.getRect(find.byType(Hero)), source);
      expect(tester.takeException(), isNull);

      // Closing a zoomed poster must also return cleanly to its detail image.
      await tester.tap(find.byType(EventPosterImage));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('포스터 확대'));
      await tester.pumpAndSettle();
      if (duo) {
        await tester.binding.handlePopRoute();
      } else {
        await tester.tap(find.byTooltip('닫기'));
      }
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final fromZoom = tester.getRect(flightImage);
      expect(fromZoom.width, lessThanOrEqualTo(target.width));
      expect(fromZoom.height, lessThanOrEqualTo(target.height));
      expect(fromZoom.left, greaterThanOrEqualTo(0));
      expect(fromZoom.right, lessThanOrEqualTo(duo ? 480 : 402));
      expect(fromZoom.top, greaterThanOrEqualTo(0));
      expect(fromZoom.bottom, lessThanOrEqualTo(duo ? 700 : 874));
      await tester.pumpAndSettle();
      expect(find.byType(EventPosterViewer), findsNothing);
      expect(tester.getRect(find.byType(Hero)), source);
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(402, 874), const Size(1000, 700)]) {
    testWidgets('poster travels from the card and returns at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await cachePoster(tester);
      final shared = const Event(id: 42, thumbnail: _url, title: '간호 학술대회').obs;
      final navigator = GlobalKey<NavigatorState>();
      final destinationWidth = size.width > 600 ? 420.0 : 362.0;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 180, left: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 120, child: EventCard(eventRx: shared)),
                  // Equal event values and a shared Rx in another list are legal.
                  SizedBox(
                    width: 120,
                    child: EventCard(eventRx: shared.value.obs),
                  ),
                  SizedBox(
                    width: 120,
                    child: BookmarkEventCard(eventRx: shared),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final heroes = tester.widgetList<Hero>(find.byType(Hero)).toList();
      final origin = tester.getRect(find.byType(Hero).first);
      navigator.currentState!.push<void>(
        PageRouteBuilder(
          transitionDuration: DuoMotion.duration,
          reverseTransitionDuration: DuoMotion.duration,
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
          pageBuilder: (_, _, _) => Scaffold(
            body: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: 80,
                  width: destinationWidth,
                  height: destinationWidth * 3 / 4,
                  child: EventPosterImage(
                    imageUrl: _url,
                    heroTag: heroes.first.tag,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      final flying = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image == const CachedNetworkImageProvider(_url),
      );
      // The two unselected cards remain visible below the flying poster.
      expect(flying, findsNWidgets(3));
      final inFlight = tester.getRect(flying.last);
      expect(inFlight.width, greaterThan(origin.width));
      expect(inFlight.width, lessThan(destinationWidth));
      expect(inFlight.top, lessThan(origin.top));
      expect(inFlight.top, greaterThan(80));
      await tester.pumpAndSettle();
      expect(tester.getRect(flying).width, destinationWidth);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(Hero).first), origin);
      expect(find.byType(EventCard), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('missing posters and reduced motion do not create hero flights', (
    tester,
  ) async {
    await cachePoster(tester);
    for (final reduceMotion in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduceMotion),
            child: Row(
              children: [
                const SizedBox(
                  width: 120,
                  height: 90,
                  child: EventPosterImage(imageUrl: '', heroTag: 'missing'),
                ),
                SizedBox(
                  width: 120,
                  height: 300,
                  child: EventCard(
                    eventRx: const Event(id: 42, thumbnail: _url).obs,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Hero), reduceMotion ? findsNothing : findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
