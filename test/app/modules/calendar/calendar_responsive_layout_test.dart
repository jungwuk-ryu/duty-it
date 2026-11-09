import 'dart:ui' show SemanticsAction;

import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/calendar/models/calendar_event.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar_day_header.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Setting implements AppSetting<bool> {
  @override
  final rxValue = false.obs;
  @override
  bool get value => rxValue.value;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Settings extends GetxService implements AppSettingsService {
  @override
  final includeDeviceEvents = _Setting();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DeviceCalendar extends GetxService implements CalendarService {
  @override
  final revision = 0.obs;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Calendar extends GetxController implements CalendarViewController {
  @override
  Stream<int> get sessionChanges => const Stream.empty();
  @override
  Stream<List<CalendarEvent>> getCalendarEvents(DateTime date) =>
      Stream.value([]);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<AppSettingsService>(_Settings());
    Get.put<CalendarService>(_DeviceCalendar());
    Get.put<CalendarViewController>(_Calendar());
  });
  tearDown(Get.reset);

  Future<void> show(
    WidgetTester tester,
    Size size, {
    double scale = 1,
    DuoLayoutData layout = const DuoLayoutData(),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(scale),
          ),
          child: DuoLayoutScope(
            data: layout,
            child: Scaffold(body: CustomCalendar(date: DateTime(2026, 8))),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets(
      'all six-week month dates remain tappable in short landscape at $scale text',
      (tester) async {
        await show(tester, const Size(944, 380), scale: scale);
        // At large text the compact layout scrolls; the month must remain reachable.
        final last = find.bySemanticsLabel('2026년 8월 31일');
        if (last.hitTestable().evaluate().isEmpty) {
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -700),
          );
          await tester.pumpAndSettle();
        }
        expect(last.hitTestable(), findsOneWidget);
        await tester.tap(last);
        await tester.pumpAndSettle();
        expect(find.text('8월 31일 (월)'), findsOneWidget);
        final day = find.byWidgetPredicate(
          (widget) =>
              widget is DayHeader &&
              widget.date.year == 2026 &&
              widget.date.month == 8 &&
              widget.date.day == 31,
        );
        final text = find.descendant(of: day, matching: find.text('31'));
        final circle = find.descendant(
          of: day,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.decoration is BoxDecoration,
          ),
        );
        final textRect = tester.getRect(text);
        final circleRect = tester.getRect(circle);
        expect(circleRect.top, lessThanOrEqualTo(textRect.top));
        expect(circleRect.bottom, greaterThanOrEqualTo(textRect.bottom));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'phone month scrolls above the draggable agenda without selecting on drag',
    (tester) async {
      await show(tester, const Size(392, 420));
      final last = find.bySemanticsLabel('2026년 8월 31일');
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle();
      expect(last.hitTestable(), findsOneWidget);
      expect(find.text('8월 1일 (토)'), findsOneWidget);
      final node = tester.getSemantics(last);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      tester
          .renderObject(last)
          .owner!
          .semanticsOwner!
          .performAction(node.id, SemanticsAction.tap);
      await tester.pumpAndSettle();
      expect(find.text('8월 31일 (월)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'agenda extent resets consistently across wide and narrow windows',
    (tester) async {
      await show(tester, const Size(392, 600));
      final sheet = tester.widget<DraggableScrollableSheet>(
        find.byType(DraggableScrollableSheet),
      );
      await tester.drag(find.text('일정 없음'), const Offset(0, -250));
      await tester.pumpAndSettle();
      expect(sheet.controller!.size, greaterThan(sheet.initialChildSize));
      await show(tester, const Size(944, 600));
      expect(find.byType(DraggableScrollableSheet), findsNothing);
      await show(tester, const Size(392, 600));
      final calendarViewport = tester.getRect(
        find.byType(SingleChildScrollView),
      );
      final agendaViewport = tester.getRect(find.byType(CustomScrollView));
      expect(calendarViewport.bottom, closeTo(agendaViewport.top, 1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Duo calendar and agenda stay on opposite sides of the fold', (
    tester,
  ) async {
    await show(
      tester,
      const Size(1000, 420),
      layout: const DuoLayoutData(
        isDuo: true,
        divisions: [Rect.fromLTWH(480, 0, 24, 420)],
        contentBounds: Rect.fromLTWH(0, 0, 1000, 420),
      ),
    );
    for (var day = 1; day <= 31; day++) {
      expect(
        tester.getRect(find.bySemanticsLabel('2026년 8월 $day일')).right,
        lessThanOrEqualTo(480),
      );
    }
    expect(tester.getRect(find.text('일정 없음')).left, greaterThanOrEqualTo(504));
    expect(tester.takeException(), isNull);
  });
}
