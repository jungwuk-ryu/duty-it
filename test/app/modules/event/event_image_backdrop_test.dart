import 'dart:math' as math;
import 'dart:typed_data';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/theme/app_theme.dart';
import 'package:duty_it/app/modules/event/widgets/event_image_backdrop.dart';
import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const poster = AssetImage('assets/icons/paper.png');
  final decoded = ResizeImage(
    poster,
    width: 256,
    height: 256,
    policy: ResizeImagePolicy.fit,
  );

  for (final dark in [false, true]) {
    testWidgets(
      'poster wash preserves readable text in ${dark ? 'dark' : 'light'} mode',
      (tester) async {
        late AppPalette local;
        late ThemeData localTheme;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: EventImageBackdrop(
              image: poster,
              child: Builder(
                builder: (context) {
                  local = context.colors;
                  localTheme = Theme.of(context);
                  return const SizedBox.expand();
                },
              ),
            ),
          ),
        );
        await tester.runAsync(
          () => precacheImage(
            decoded,
            tester.element(find.byType(EventImageBackdrop)),
          ),
        );
        await tester.pumpAndSettle();
        final wash = tester
            .widget<ColoredBox>(
              find.descendant(
                of: find.byType(Image),
                matching: find.byType(ColoredBox),
              ),
            )
            .color;
        for (final imageColor in [
          Colors.black,
          Colors.white,
          Colors.red,
          Colors.green,
          Colors.blue,
        ]) {
          final background = Color.alphaBlend(wash, imageColor);
          for (final foreground in [
            local.text,
            local.secondaryText,
            local.muted,
            local.accent,
            local.link,
          ]) {
            expect(
              _contrast(foreground, background),
              greaterThanOrEqualTo(4.5),
              reason: '$foreground on $background',
            );
          }
        }
        expect(local.canvas.a, 0);
        expect(localTheme.brightness, Brightness.dark);
        expect(local.text, AppPalette.dark.text);
        expect(
          localTheme.appBarTheme.systemOverlayStyle!.statusBarIconBrightness,
          Brightness.light,
        );
        expect(
          Theme.of(tester.element(find.byType(EventImageBackdrop))).brightness,
          dark ? Brightness.dark : Brightness.light,
        );
        expect(find.byType(ImageFiltered), findsOneWidget);
        expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
        final image = tester.widget<Image>(find.byType(Image));
        final provider = image.image as ResizeImage;
        expect(provider.policy, ResizeImagePolicy.fit);
        expect(provider.width, lessThanOrEqualTo(256));
        expect(provider.height, lessThanOrEqualTo(256));
        expect(image.excludeFromSemantics, isTrue);
      },
    );
  }

  testWidgets(
    'poster overlay uses the live app theme instead of the ambient theme snapshot',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: EventImageBackdrop(
            image: poster,
            child: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () => EventPosterViewer.show(
                    context,
                    image: poster,
                    title: '포스터',
                    host: '주최',
                  ),
                  child: const Text('전체 보기'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(poster, tester.element(find.byType(TextButton))),
      );
      await tester.tap(find.text('전체 보기'));
      await tester.pumpAndSettle();
      final viewer = find.byType(EventPosterViewer);
      expect(tester.element(viewer).colors.surface.a, 1);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();
      expect(Theme.of(tester.element(viewer)).brightness, Brightness.dark);
      expect(tester.element(viewer).colors.surface, AppPalette.dark.surface);
      await tester.tap(find.byTooltip('닫기'));
      await tester.pumpAndSettle();
      expect(find.text('전체 보기'), findsOneWidget);
    },
  );

  testWidgets(
    'decorative background stays fixed while the existing content scrolls',
    (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: EventImageBackdrop(
            image: poster,
            child: ListView(
              controller: scroll,
              children: const [SizedBox(height: 1600, child: Text('행사 내용'))],
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(
          decoded,
          tester.element(find.byType(EventImageBackdrop)),
        ),
      );
      await tester.pumpAndSettle();
      final filter = find.byType(ImageFiltered);
      final before = tester.getRect(filter);
      final layer = tester.layers.whereType<ImageFilterLayer>().single;
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(scroll.offset, greaterThan(0));
      expect(tester.getRect(filter), before);
      expect(tester.layers.whereType<ImageFilterLayer>().single, same(layer));
      expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
    },
  );

  testWidgets(
    'light mode keeps its content state and returns to light fallback when effects are off',
    (tester) async {
      var highContrast = false;
      var reduceTransparency = false;
      ImageProvider? image;
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: StatefulBuilder(
            builder: (context, set) {
              update = set;
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(highContrast: highContrast),
                child: DuoLayoutScope(
                  data: DuoLayoutData(reduceTransparency: reduceTransparency),
                  child: EventImageBackdrop(
                    image: image,
                    child: const Scaffold(
                      backgroundColor: Colors.transparent,
                      body: TextField(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '유지할 메모');
      final inputState = tester.state(find.byType(TextField));
      expect(
        tester.element(find.byType(TextField)).colors.canvas,
        AppPalette.light.canvas,
      );
      update(() => image = poster);
      await tester.runAsync(
        () => precacheImage(
          decoded,
          tester.element(find.byType(EventImageBackdrop)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ImageFiltered), findsOneWidget);
      expect(
        Theme.of(tester.element(find.byType(TextField))).brightness,
        Brightness.dark,
      );
      for (final setting in ['contrast', 'transparency']) {
        update(() {
          highContrast = setting == 'contrast';
          reduceTransparency = setting == 'transparency';
        });
        await tester.pumpAndSettle();
        expect(find.byType(Image), findsNothing);
        expect(find.byType(ImageFiltered), findsNothing);
        expect(
          tester.element(find.byType(TextField)).colors.canvas,
          AppPalette.light.canvas,
        );
        expect(
          Theme.of(tester.element(find.byType(TextField))).brightness,
          Brightness.light,
        );
        expect(tester.state(find.byType(TextField)), same(inputState));
        expect(find.text('유지할 메모'), findsOneWidget);
      }
    },
  );

  testWidgets(
    'failed poster leaves a solid canvas and does not block actions',
    (tester) async {
      var tapped = false;
      final broken = MemoryImage(Uint8List.fromList([0, 1, 2]));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: EventImageBackdrop(
            image: broken,
            child: Center(
              child: TextButton(
                onPressed: () => tapped = true,
                child: const Text('더 보기'),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await precacheImage(
          ResizeImage(
            broken,
            width: 256,
            height: 256,
            policy: ResizeImagePolicy.fit,
          ),
          tester.element(find.byType(EventImageBackdrop)),
          onError: (_, _) {},
        );
      });
      await tester.pumpAndSettle();
      expect(find.byType(ImageFiltered), findsNothing);
      final canvas = tester
          .widgetList<ColoredBox>(
            find.descendant(
              of: find.byType(EventImageBackdrop),
              matching: find.byType(ColoredBox),
            ),
          )
          .first;
      expect(canvas.color, AppPalette.dark.canvas);
      expect(
        _contrast(
          tester.element(find.byType(TextButton)).colors.text,
          canvas.color,
        ),
        greaterThanOrEqualTo(4.5),
      );
      await tester.tap(find.text('더 보기'));
      expect(tapped, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

double _contrast(Color first, Color second) {
  final a = first.computeLuminance(), b = second.computeLuminance();
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}
