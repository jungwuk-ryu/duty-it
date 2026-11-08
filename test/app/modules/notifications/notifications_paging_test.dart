import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/notifications/controllers/notifications_view_controller.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/modules/notifications/views/notifications_view.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

const _event = AppNotification(id: 1, type: 'EVENT_START', isRead: true);
const _job = AppNotification(
  id: 2,
  type: 'JOB_SUBSCRIPTION_KEYWORD',
  isRead: true,
);

class _Api extends ApiClient {
  final keys = <int>[];
  final requests = <Completer<RequestResult<List<AppNotification>>>>[];
  int markAsReadCount = 0;

  @override
  void onInit() {}

  @override
  Future<RequestResult<List<AppNotification>>> getNotificationList(
    int page, {
    int size = 10,
  }) {
    keys.add(page);
    final request = Completer<RequestResult<List<AppNotification>>>();
    requests.add(request);
    return request.future;
  }

  @override
  Future<RequestResult<List<NotificationSubscription>>> getSubscriptions({
    NotificationSubscriptionType? type,
  }) async => RequestSuccess([]);

  @override
  Future<RequestResult<bool>> readAllNotification() async {
    markAsReadCount++;
    return RequestSuccess(true);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Api api;

  setUp(() {
    api = _Api();
    Get.put<ApiClient>(api);
  });
  tearDown(Get.reset);

  testWidgets(
    'a bodyless error on an empty filter waits for the retry button',
    (tester) async {
      final controller = Get.put(NotificationsViewController());
      api.requests.single.complete(RequestSuccess([_event]));
      await tester.pumpWidget(const GetMaterialApp(home: NotificationsView()));
      await tester.tap(find.text('채용'));
      await tester.pump();
      expect(api.keys, [0, 1]);

      api.requests.last.complete(RequestFail(null));
      await tester.pumpAndSettle();
      expect(find.text('알림을 불러오지 못했어요'), findsOneWidget);
      expect(find.text('알림 목록이 비어 있습니다'), findsNothing);

      await tester.tap(find.text('채용'));
      await controller
          .fetchNotificationList(); // The near-bottom scroll callback.
      await tester.pump();
      expect(api.keys, [0, 1]);

      await tester.tap(find.text('다시 시도'));
      expect(api.keys, [0, 1, 1]);
      api.requests.last.complete(RequestSuccess([_job]));
      await tester.pumpAndSettle();
      expect(controller.filteredNotifications, [_job]);
      expect(find.text('다시 시도'), findsNothing);
    },
  );

  test(
    'switching tabs while searching stops the scan at the current page',
    () async {
      final controller = Get.put(NotificationsViewController());
      controller.selectTab(NotificationTab.job);
      api.requests.single.complete(RequestSuccess([_event]));
      await Future<void>.delayed(Duration.zero);
      expect(api.keys, [0, 1]);

      controller.selectTab(NotificationTab.event);
      api.requests.last.complete(RequestSuccess([_job]));
      await Future<void>.delayed(Duration.zero);
      expect(api.keys, [0, 1]);
      expect(controller.filteredNotifications, [_event]);
      expect(controller.pagingState.isLoading, isFalse);
    },
  );

  test(
    'a late response cannot overwrite a refreshed page or restart its scan',
    () async {
      final controller = Get.put(NotificationsViewController());
      controller.selectTab(NotificationTab.job);
      final refresh = controller.refreshNotificationList();
      expect(api.keys, [0, 0]);
      api.requests.last.complete(RequestSuccess([_job]));
      await refresh;

      api.requests.first.complete(RequestSuccess([_event]));
      await Future<void>.delayed(Duration.zero);
      expect(controller.filteredNotifications, [_job]);
      expect(controller.pageError, isNull);
      expect(api.keys, [0, 0]);
    },
  );

  test(
    'closing the route drops its in-flight result and further requests',
    () async {
      final controller = Get.put(NotificationsViewController());
      controller.selectTab(NotificationTab.job);
      await Get.delete<NotificationsViewController>();
      api.requests.single.complete(RequestSuccess([_event]));
      await Future<void>.delayed(Duration.zero);
      expect(controller.pagingState.pages, isNull);
      expect(api.keys, [0]);
      expect(api.markAsReadCount, 0);
    },
  );
}
