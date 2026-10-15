import 'dart:io';

import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/widgets/calendar_permission_notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FakeCalendarService extends CalendarService {
  FakeCalendarService({required this.hasPermission});

  bool hasPermission;
  int requestCount = 0;

  @override
  Future<bool> checkPermission() async => hasPermission;

  @override
  Future<bool> requestPermission() async {
    requestCount++;
    hasPermission = true;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return Directory.systemTemp.path;
          }
          return null;
        });

    await GetStorage.init(CalendarService.registeredEventsBoxName);
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  testWidgets('skips the notice when permission is already granted', (
    tester,
  ) async {
    final service =
        Get.put<CalendarService>(FakeCalendarService(hasPermission: true))
            as FakeCalendarService;
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

    final result = await CalendarPermissionNoticeDialog.requestPermission();
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.text(CalendarPermissionNoticeDialog.title), findsNothing);
    expect(service.requestCount, 0);
  });

  testWidgets('does not request permission when the notice is cancelled', (
    tester,
  ) async {
    final service =
        Get.put<CalendarService>(FakeCalendarService(hasPermission: false))
            as FakeCalendarService;
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

    final future = CalendarPermissionNoticeDialog.requestPermission();
    await tester.pumpAndSettle();
    expect(find.text(CalendarPermissionNoticeDialog.title), findsOneWidget);
    expect(find.text(CalendarPermissionNoticeDialog.content), findsOneWidget);

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();

    expect(await future, isNull);
    expect(service.requestCount, 0);
  });

  testWidgets('requests permission only after continue is tapped', (
    tester,
  ) async {
    final service =
        Get.put<CalendarService>(FakeCalendarService(hasPermission: false))
            as FakeCalendarService;
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

    final future = CalendarPermissionNoticeDialog.requestPermission();
    await tester.pumpAndSettle();
    expect(service.requestCount, 0);

    await tester.tap(find.text('계속'));
    await tester.pumpAndSettle();

    expect(await future, isTrue);
    expect(service.requestCount, 1);
  });
}
