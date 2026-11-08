import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/sort_direction.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/modules/account/controllers/account_view_controller.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_filter_controller.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../helpers/fake_firebase_auth.dart';

class _Hosts extends ApiClient {
  @override
  void onInit() {}

  @override
  Future<RequestResult<List<Host>>> getHosts({
    int page = 0,
    int size = 10,
    SortDirection? sortDirection,
    String? field,
  }) async => RequestSuccess(const [
    Host(id: 1, name: '한국심초음파학회'),
    Host(id: 2, name: '한국심장재단'),
  ]);
}

class _SearchFilter extends SearchFilterService {
  @override
  // The fixture does not persist filters.
  // ignore: must_call_super
  void onInit() {}
}

class _NotificationFilter extends NotificationFilterController {
  @override
  // Only the local selection flow is needed here.
  // ignore: must_call_super
  void onReady() {}
}

class _JobFilter extends JobFilterViewController {
  @override
  final service = JobFilterService();
}

class _Auth extends AuthService {
  @override
  // The fixture never authenticates or modifies a real account.
  // ignore: must_call_super
  void onInit() {}
}

class _Account extends AccountViewController {
  @override
  // Skip the account API request.
  // ignore: must_call_super
  void onInit() {}
  @override
  String getUserName() => '듀잇';
}

class _Calendar extends CalendarViewController {
  _Calendar() : super(auth: FakeFirebaseAuth());
  @override
  // The month picker needs no storage or device calendar access.
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  const channel = MethodChannel('com.dutyit.app/layout');
  const codec = StandardMethodCodec();
  setUp(() {
    Get.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    Get.put<ApiClient>(_Hosts());
    Get.put<SearchFilterService>(_SearchFilter());
    Get.put(SearchFilterViewController());
    Get.put<NotificationFilterController>(_NotificationFilter());
    Get.put<JobFilterViewController>(_JobFilter());
    Get.put<AuthService>(_Auth());
    Get.put<AccountViewController>(_Account());
    Get.put<CalendarViewController>(_Calendar());
  });
  tearDown(() {
    Get.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> nativeLayout(WidgetTester tester, {bool fold = false}) async {
    tester.binding.channelBuffers.push(
      channel.name,
      codec.encodeSuccessEnvelope({
        'isDuo': true,
        'verticalBarEdge': 'right',
        'layoutMargins': {'left': 20, 'right': 84, 'bottom': 34},
        'divisions': [
          if (fold) {'x': 480, 'y': 0, 'width': 24, 'height': 700},
        ],
      }),
      (_) {},
    );
    await tester.pumpAndSettle();
  }

  Future<void> mount(
    WidgetTester tester,
    VoidCallback open, {
    bool folded = false,
    bool phone = false,
    double keyboard = 0,
  }) async {
    tester.view.physicalSize = folded
        ? const Size(1000, 700)
        : const Size(466, 678);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.only(right: phone ? 0 : 84, bottom: 34),
            viewPadding: EdgeInsets.only(right: phone ? 0 : 84, bottom: 34),
            viewInsets: EdgeInsets.only(bottom: keyboard),
          ),
          child: DuoLayout(child: child!),
        ),
        home: CupertinoPageScaffold(
          child: Center(
            child: CupertinoButton(onPressed: open, child: const Text('열기')),
          ),
        ),
      ),
    );
    if (!phone) await nativeLayout(tester, fold: folded);
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
  }

  final sheets = <String, VoidCallback Function()>{
    '검색 주최': () =>
        Get.find<SearchFilterViewController>().showHostSelectionBottomModal,
    '알림 주최': () =>
        Get.find<NotificationFilterController>().showHostSelectionBottomModal,
    '채용 지역': () =>
        Get.find<JobFilterViewController>().showRegionSelectionBottomModal,
    '닉네임': () => Get.find<AccountViewController>().onUserNameEditButtonClicked,
    '월': () => Get.find<CalendarViewController>().showDateSelectionBottomModal,
  };

  for (final entry in sheets.entries) {
    for (final folded in [false, true]) {
      testWidgets(
        '${entry.key} sheet surface avoids the Duo rail and hinge (folded $folded)',
        (tester) async {
          await mount(tester, entry.value(), folded: folded);
          final surface = tester.getRect(find.byType(BottomSheet));
          expect(surface.left, 4);
          expect(surface.right, folded ? 480 : 466 - 84);
          expect(tester.takeException(), isNull);
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.byType(BottomSheet), findsNothing);
        },
        variant: TargetPlatformVariant.only(TargetPlatform.iOS),
      );
    }
  }

  for (final notifications in [false, true]) {
    testWidgets(
      'host search and selection remain usable above keyboard (notifications $notifications)',
      (tester) async {
        await mount(
          tester,
          notifications ? sheets['알림 주최']!() : sheets['검색 주최']!(),
          keyboard: 290,
        );
        await tester.enterText(find.byType(TextField), '심장');
        await tester.pumpAndSettle(const Duration(milliseconds: 250));
        final field = tester.getRect(find.byType(TextField));
        expect(field.right, lessThanOrEqualTo(382));
        expect(field.bottom, lessThanOrEqualTo(678 - 290));
        expect(find.text('한국심초음파학회'), findsNothing);
        await tester.tap(find.text('한국심장재단'));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        if (notifications) {
          expect(Get.find<NotificationFilterController>().drafts.length, 1);
        } else {
          expect(Get.find<SearchFilterViewController>().selectedHost?.id, 2);
        }
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );
  }

  testWidgets('an open host sheet follows native folding and unfolding', (
    tester,
  ) async {
    await mount(tester, sheets['검색 주최']!(), folded: true);
    expect(
      tester.getRect(find.byType(BottomSheet)).right,
      lessThanOrEqualTo(480),
    );
    await tester.enterText(find.byType(TextField), '심장');
    await tester.pumpAndSettle(const Duration(milliseconds: 250));
    await nativeLayout(tester);
    expect(tester.getRect(find.byType(BottomSheet)).right, 916);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '심장',
    );
    await tester.tap(find.text('한국심장재단'));
    await tester.pumpAndSettle();
    expect(Get.find<SearchFilterViewController>().selectedHost?.id, 2);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  for (final withdraw in [false, true]) {
    testWidgets('account confirmation avoids the hinge (withdraw $withdraw)', (
      tester,
    ) async {
      await mount(tester, () {
        final account = Get.find<AccountViewController>();
        withdraw ? account.withdraw() : account.logout();
      }, folded: true);
      final cancel = tester.getRect(find.text('취소'));
      expect(cancel.right, lessThan(480));
      expect(
        tester
            .getRect(
              find.text(
                withdraw ? '탈퇴 하시겠습니까?\n이 작업은 복구할 수 없습니다.' : '로그아웃 하시겠습니까?',
              ),
            )
            .right,
        lessThan(480),
      );
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsNothing);
      expect(find.text('열기'), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  }

  testWidgets('ordinary phone host sheet keeps full available width', (
    tester,
  ) async {
    await mount(tester, sheets['검색 주최']!(), phone: true);
    expect(tester.getRect(find.byType(BottomSheet)).left, 0);
    expect(tester.getRect(find.byType(BottomSheet)).right, 466);
    await tester.tap(find.text('한국심장재단'));
    await tester.pumpAndSettle();
    expect(Get.find<SearchFilterViewController>().selectedHost?.id, 2);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
}
