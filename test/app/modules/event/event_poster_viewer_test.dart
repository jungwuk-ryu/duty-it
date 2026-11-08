import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'double tap keeps the touched point fixed; fit button restores the full poster',
    (tester) async {
      const image = AssetImage('assets/icons/paper.png');
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => EventPosterViewer.show(
                context,
                image: image,
                title: '봉사자 모집',
                host: '주최 기관',
              ),
              child: const Text('열기'),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await precacheImage(image, tester.element(find.byType(TextButton)));
      });
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      final viewer = find.byType(InteractiveViewer);
      final transform = tester
          .widget<InteractiveViewer>(viewer)
          .transformationController!;
      final poster = tester.getRect(find.byType(RawImage));
      final focal =
          poster.center + Offset(poster.width / 4, -poster.height / 4);
      final local = focal - tester.getTopLeft(viewer);
      await tester.tapAt(focal);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tapAt(focal);
      await tester.pumpAndSettle();
      expect(transform.value.getMaxScaleOnAxis(), closeTo(2.5, .001));
      expect((transform.toScene(local) - local).distance, lessThan(.001));
      await tester.tap(find.byTooltip('전체 맞춤'));
      await tester.pumpAndSettle();
      expect(transform.value.isIdentity(), isTrue);
      await tester.tap(find.byTooltip('닫기'));
      await tester.pumpAndSettle();
      expect(find.text('열기'), findsOneWidget);
      expect(viewer, findsNothing);
    },
  );
  testWidgets('zoom from the letterbox keeps a wide poster visible', (
    tester,
  ) async {
    await _openWidePoster(tester, const Size(390, 844));
    final viewer = find.byType(InteractiveViewer);
    final viewport = tester.getRect(viewer);
    final poster = find.byType(RawImage);
    final original = tester.getRect(poster);
    final tap = viewport.topCenter + const Offset(0, 8);
    expect(tap.dy, lessThan(original.top));
    await tester.tapAt(tap);
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tapAt(tap);
    await tester.pumpAndSettle();
    final zoomed = tester.getRect(poster);
    expect(zoomed.width, closeTo(original.width * 2.5, .01));
    expect(zoomed.top, closeTo(original.top, .01));
    expect(viewport.overlaps(zoomed), isTrue);
  });
  testWidgets(
    'a short pane keeps the poster and its controls usable at large type',
    (tester) async {
      await _openWidePoster(tester, const Size(670, 230), textScale: 3.2);
      expect(tester.takeException(), isNull);
      final viewer = find.byType(InteractiveViewer);
      expect(tester.getSize(viewer).height, greaterThan(90));
      expect(tester.getSize(find.byType(RawImage)).height, greaterThan(0));
      final caption = find.byType(SingleChildScrollView);
      final scrollable = tester.state<ScrollableState>(
        find.descendant(of: caption, matching: find.byType(Scrollable)),
      );
      await tester.drag(caption, const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(scrollable.position.pixels, greaterThan(0));
      await tester.tap(find.byTooltip('포스터 확대'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('전체 맞춤'), findsOneWidget);
      expect(find.byTooltip('닫기').hitTestable(), findsOneWidget);
    },
  );
  testWidgets('failed load can retry and zoom with reduced motion', (
    tester,
  ) async {
    final pixels = await tester.runAsync(
      () => createTestImage(width: 32, height: 64),
    );
    var requests = 0;
    final image = _TestPoster(
      () => ++requests == 1
          ? Future.error(StateError('Image unavailable'))
          : SynchronousFuture(ImageInfo(image: pixels!.clone())),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: EventPosterViewer(image: image, title: '행사', host: ''),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('닫기'), findsOneWidget);
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('포스터 확대'));
    await tester.pump();
    final transform = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    expect(transform.value.getMaxScaleOnAxis(), 2.5);
    expect(find.byTooltip('전체 맞춤'), findsOneWidget);
  });
  testWidgets(
    'a newly active Duo fold refits the zoomed poster in its source pane',
    (tester) async {
      final folds = ValueNotifier<List<Rect>>([]);
      addTearDown(folds.dispose);
      const image = AssetImage('assets/icons/paper.png');
      await tester.pumpWidget(
        MaterialApp(
          builder: (_, child) => ValueListenableBuilder(
            valueListenable: folds,
            builder: (_, value, _) => DuoLayoutScope(
              data: DuoLayoutData(isDuo: true, divisions: value),
              child: child!,
            ),
          ),
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) => TextButton(
                  onPressed: () => EventPosterViewer.show(
                    context,
                    image: image,
                    title: '행사',
                    host: '',
                  ),
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(image, tester.element(find.byType(TextButton))),
      );
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('포스터 확대'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('전체 맞춤'), findsOneWidget);
      folds.value = [const Rect.fromLTWH(388, 0, 24, 600)];
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(EventPosterViewer)).left, 412);
      expect(find.byTooltip('포스터 확대'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _openWidePoster(
  WidgetTester tester,
  Size size, {
  double textScale = 1,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final pixels = (await tester.runAsync(
    () => createTestImage(width: 1200, height: 400),
  ))!;
  addTearDown(pixels.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: EventPosterViewer(
          image: _TestPoster(
            () => SynchronousFuture(ImageInfo(image: pixels.clone())),
          ),
          title: '대한중앙의료봉사회 농촌 의료 왕진버스 자원봉사자 모집 - 대구 군위군 의흥면',
          host: '대한중앙의료봉사회',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestPoster extends ImageProvider<_TestPoster> {
  const _TestPoster(this.load);
  final Future<ImageInfo> Function() load;

  @override
  Future<_TestPoster> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _TestPoster key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(load());
}
