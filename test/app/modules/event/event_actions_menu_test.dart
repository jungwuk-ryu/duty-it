import 'package:device_calendar_plus/device_calendar_plus.dart' as device;
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/modules/event/widgets/event_actions_menu.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class FakeCalendarService extends CalendarService {
  bool permission = true;
  int saves = 0;
  String? selectedCalendar;

  @override
  Future<bool> requestPermission() async => permission;
  @override
  Future<String?> findRegisteredEventId(String id) async => null;
  @override
  Future<List<device.Calendar>> getWritableCalendars() async => const [
    device.Calendar(id: 'personal', name: '개인', readOnly: false),
    device.Calendar(id: 'work', name: '업무', readOnly: false),
  ];
  @override
  Future<CalendarSaveResult> addEvent({
    required String calendarId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required String id,
    String? description,
  }) async {
    saves++;
    selectedCalendar = calendarId;
    return const CalendarSaveResult('saved', created: true);
  }
}

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> mount(
    WidgetTester tester, {
    Future<void> Function()? bookmark,
  }) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              EventActionsMenu(
                event: Event(
                  id: 42,
                  title: '간호 학술대회',
                  startAt: DateTime(2026, 10, 1, 9),
                ),
                bookmarkBusy: false,
                onBookmarkTap: bookmark ?? () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byTooltip('행사 더보기'));
    await tester.pumpAndSettle();
  }

  testWidgets('menu copies the event page link and invokes bookmark directly', (
    tester,
  ) async {
    String? copied;
    var bookmarks = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await mount(
      tester,
      bookmark: () async {
        bookmarks++;
      },
    );
    await openMenu(tester);
    expect(find.text('공유'), findsOneWidget);
    await tester.tap(find.text('링크 복사'));
    await tester.pumpAndSettle();
    expect(copied, 'https://www.dutyit.net/visitEvent/42?openIn=app');
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    await openMenu(tester);
    await tester.tap(find.text('북마크'));
    await tester.pumpAndSettle();
    expect(bookmarks, 1);
    expect(find.text('휴대폰 기본 캘린더 연동'), findsNothing);
  });

  testWidgets('saving requires calendar selection and explicit confirmation', (
    tester,
  ) async {
    final calendar = FakeCalendarService();
    Get.put<CalendarService>(calendar);
    await mount(tester);
    await openMenu(tester);
    await tester.tap(find.text('캘린더에 추가'));
    await tester.pumpAndSettle();
    expect(calendar.saves, 0);
    await tester.tap(find.text('업무'));
    await tester.pump();
    await tester.tap(find.text('선택한 캘린더에 추가'));
    await tester.pumpAndSettle();
    expect(calendar.saves, 1);
    expect(calendar.selectedCalendar, 'work');
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
  });

  testWidgets('denied calendar permission offers settings without saving', (
    tester,
  ) async {
    final calendar = FakeCalendarService()..permission = false;
    Get.put<CalendarService>(calendar);
    await mount(tester);
    await openMenu(tester);
    await tester.tap(find.text('캘린더에 추가'));
    await tester.pumpAndSettle();
    expect(find.text('설정 열기'), findsOneWidget);
    expect(calendar.saves, 0);
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();
  });
}
