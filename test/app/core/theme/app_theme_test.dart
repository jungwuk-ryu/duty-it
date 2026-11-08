import 'dart:async';
import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/modules/event/widgets/event_host_card.dart';
import 'package:duty_it/app/widgets/app_toggle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:duty_it/app/core/theme/app_theme.dart';
import 'package:duty_it/app/core/theme/app_system_ui.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_event_card.dart';
import 'package:duty_it/app/modules/event/views/event_poster_viewer.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:duty_it/app/widgets/sort_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main() {
  test('system bars keep contrasting icons in both themes', () {
    for (final brightness in Brightness.values) {
      final style = AppTheme.overlayStyle(brightness);
      expect(style.systemNavigationBarContrastEnforced, isFalse);
      expect(
        style.systemNavigationBarIconBrightness,
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      expect(
        style.statusBarIconBrightness,
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
    }
  });

  test('dark text and category colors keep readable contrast', () {
    const colors = AppPalette.dark;
    for (final surface in [
      colors.canvas,
      colors.surface,
      colors.mutedSurface,
      colors.calendarNeutral,
      colors.calendarPink,
      colors.calendarBlue,
    ]) {
      for (final foreground in [
        colors.text,
        colors.secondaryText,
        colors.muted,
      ]) {
        expect(_contrast(foreground, surface), greaterThanOrEqualTo(4.5));
      }
    }
    expect(
      _contrast(colors.disabled, colors.canvas),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrast(colors.accent, colors.accentSurface),
      greaterThanOrEqualTo(4.5),
    );
    expect(_contrast(colors.link, colors.surface), greaterThanOrEqualTo(4.5));
    expect(
      _contrast(AppColors.white, AppColors.main),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets(
    'Android navigation protection follows the theme without consuming insets',
    (tester) async {
      const padding = EdgeInsets.only(bottom: 48);
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme.copyWith(platform: TargetPlatform.android),
            home: MediaQuery(
              data: const MediaQueryData(viewPadding: padding),
              child: AppSystemUi(
                child: Builder(
                  builder: (context) {
                    expect(MediaQuery.viewPaddingOf(context), padding);
                    return const ColoredBox(color: Colors.purple);
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final protection = find.descendant(
          of: find.byType(AppSystemUi),
          matching: find.byWidgetPredicate(
            (widget) => widget is ColoredBox && widget.color != Colors.purple,
          ),
        );
        expect(
          tester.widget<ColoredBox>(protection).color,
          theme.scaffoldBackgroundColor,
        );
        expect(tester.getSize(protection).height, 48);
      }
    },
  );

  testWidgets(
    'fallback host icon contrasts with preserved white logo backing',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: EventHostCard(host: const Host(id: 1, name: '주최')),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.business_outlined));
      expect(_contrast(icon.color!, AppColors.white), greaterThanOrEqualTo(3));
    },
  );

  testWidgets(
    'pending setting remains visible on its white switch thumb in dark mode',
    (tester) async {
      final saved = Completer<void>();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: Center(
              child: AppToggleButton(checked: true, onTap: () => saved.future),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppToggleButton));
      await tester.pump();
      final progress = tester.widget<CupertinoActivityIndicator>(
        find.byType(CupertinoActivityIndicator),
      );
      expect(
        _contrast(progress.color!, AppColors.white),
        greaterThanOrEqualTo(3),
      );
      saved.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
    },
  );

  testWidgets(
    'system changes update an open menu without resetting search or selection',
    (tester) async {
      final dispatcher = tester.platformDispatcher;
      dispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(dispatcher.clearPlatformBrightnessTestValue);
      final search = TextEditingController();
      addTearDown(search.dispose);
      var selected = EventSortingType.latest;
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: StatefulBuilder(
            builder: (context, update) => Scaffold(
              body: Column(
                children: [
                  HomeSearchBar(controller: search),
                  SortMenu(
                    selected: selected,
                    options: EventSortingType.values,
                    onSelected: (value) => update(() => selected = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '간호');
      await tester.tap(find.text('최신순'));
      await tester.pumpAndSettle();
      expect(find.text('모집 마감 임박순'), findsOneWidget);
      dispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();
      final menuContext = tester.element(find.text('모집 마감 임박순'));
      expect(Theme.of(menuContext).brightness, Brightness.dark);
      expect(menuContext.colors.text, AppPalette.dark.text);
      expect(
        tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
        isNull,
      );
      expect(
        Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor,
        AppPalette.dark.canvas,
      );
      expect(search.text, '간호');
      await tester.tap(find.text('모집 마감 임박순'));
      await tester.pumpAndSettle();
      expect(selected, EventSortingType.closingSoon);
      dispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(
        tester.element(find.byType(HomeSearchBar)).colors.canvas,
        AppPalette.light.canvas,
      );
      expect(search.text, '간호');
      expect(find.text('모집 마감'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      Get.reset();
    },
  );

  testWidgets('cached calendar category colors resolve at render time', (
    tester,
  ) async {
    final event = CalendarEvent(
      title: '저장된 일정',
      startDate: DateTime(2026, 11, 9, 10),
      endDate: DateTime(2026, 11, 9, 11),
      color: AppColors.cal2,
      url: 'https://www.dutyit.net',
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: CustomCalendarEventCard(event)),
      ),
    );
    final card = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(CustomCalendarEventCard),
            matching: find.byType(Container),
          ),
        )
        .firstWhere((widget) => widget.decoration is BoxDecoration);
    expect(
      (card.decoration! as BoxDecoration).color,
      AppPalette.dark.calendarPink,
    );
    expect(event.color, AppColors.cal2);
    expect(
      tester.widget<Text>(find.text('저장된 일정')).style!.color,
      AppPalette.dark.text,
    );
  });

  testWidgets('dark accessibility fallback is opaque and keeps its action', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(highContrast: true),
          child: DuoLayoutScope(
            data: const DuoLayoutData(reduceTransparency: true),
            child: Scaffold(
              body: DuitGlass(
                child: TextButton(
                  onPressed: () => tapped = true,
                  child: const Text('메뉴'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(LiquidGlass), findsNothing);
    final backgrounds = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(DuitGlass),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<BoxDecoration>();
    expect(
      backgrounds.any((box) => box.color == AppPalette.dark.surface),
      isTrue,
    );
    await tester.tap(find.text('메뉴'));
    expect(tapped, isTrue);
  });

  testWidgets(
    'poster viewer uses dark chrome and preserves original poster paper',
    (tester) async {
      const image = AssetImage('assets/icons/paper.png');
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => EventPosterViewer.show(
                context,
                image: image,
                title: '포스터',
                host: '주최',
              ),
              child: const Text('열기'),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(image, tester.element(find.byType(TextButton))),
      );
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      final overlay = tester
          .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
            find.descendant(
              of: find.byType(EventPosterViewer),
              matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
            ),
          )
          .single;
      expect(overlay.value.statusBarBrightness, Brightness.dark);
      final boxes = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(EventPosterViewer),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>();
      expect(boxes.any((box) => box.color == Colors.white), isTrue);
      expect(
        tester
            .widget<Icon>(
              find.descendant(
                of: find.byTooltip('닫기'),
                matching: find.byType(Icon),
              ),
            )
            .color,
        AppPalette.dark.text,
      );
      await tester.tap(find.byTooltip('닫기'));
      await tester.pumpAndSettle();
      expect(find.text('열기'), findsOneWidget);
    },
  );
}

double _contrast(Color first, Color second) {
  final a = first.computeLuminance(), b = second.computeLuminance();
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}
