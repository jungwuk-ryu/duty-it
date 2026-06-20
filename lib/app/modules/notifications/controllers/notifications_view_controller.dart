import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_filter_controller.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum NotificationTab { all, event, job }

class NotificationsViewController extends GetxController {
  ApiClient get _apiClient => Get.find<ApiClient>();
  bool _didMarkAllAsRead = false;
  static const int _pageSize = 20;

  final Rx<NotificationTab> selectedTab = NotificationTab.all.obs;
  final RxList<NotificationSubscription> subscriptions =
      <NotificationSubscription>[].obs;
  final RxBool isResolvingFilteredTab = false.obs;

  final Rx<PagingState<int, AppNotification>> _pagingState =
      PagingState<int, AppNotification>().obs;
  PagingState<int, AppNotification> get pagingState => _pagingState.value;
  set pagingState(PagingState<int, AppNotification> state) =>
      _pagingState.value = state;

  @override
  void onInit() {
    super.onInit();

    bool isMarkingAllAsRead = false;
    _pagingState.listen((state) async {
      if (_didMarkAllAsRead) return;
      if ((state.pages?.isNotEmpty ?? false) && !isMarkingAllAsRead) {
        isMarkingAllAsRead = true;

        try {
          _didMarkAllAsRead = await markAllAsRead();
        } finally {
          isMarkingAllAsRead = false;
        }
      }
    });

    fetchNotificationList();
    fetchSubscriptions();
  }

  List<AppNotification> get notifications =>
      (pagingState.pages ?? const <List<AppNotification>>[])
          .expand((page) => page)
          .toList(growable: false);

  List<AppNotification> get filteredNotifications {
    final tab = selectedTab.value;
    return notifications
        .where((notification) {
          return switch (tab) {
            NotificationTab.all => true,
            NotificationTab.event => _isEventNotification(notification),
            NotificationTab.job => _isJobNotification(notification),
          };
        })
        .toList(growable: false);
  }

  bool get isInitialLoading =>
      pagingState.isLoading && (pagingState.pages?.isEmpty ?? true);

  bool get isLoadingMore =>
      pagingState.isLoading && (pagingState.pages?.isNotEmpty ?? false);

  Object? get pageError => pagingState.error;

  bool get hasFirstPageError => pageError != null && notifications.isEmpty;

  bool get hasNextPageError => pageError != null && notifications.isNotEmpty;

  bool get hasEventCondition =>
      subscriptions.any((subscription) => subscription.type.isEvent);

  bool get hasJobCondition =>
      subscriptions.any((subscription) => subscription.type.isJob);

  String? get conditionMessage {
    return switch (selectedTab.value) {
      NotificationTab.event when !hasEventCondition => '행사공고 알림 조건이 설정되지 않았어요',
      NotificationTab.job when !hasJobCondition => '채용공고 알림 조건이 설정되지 않았어요',
      _ => null,
    };
  }

  bool get hasNextPage => pagingState.hasNextPage;

  void selectTab(NotificationTab tab) {
    selectedTab.value = tab;
    _ensureSelectedTabHasVisibleItems();
  }

  Future<void> refreshNotificationList() async {
    await fetchNotificationList(clearPage: true);
    await fetchSubscriptions();
    await _ensureSelectedTabHasVisibleItems();
  }

  Future<void> fetchNotificationList({bool clearPage = false}) async {
    if (!clearPage && (pagingState.isLoading || !pagingState.hasNextPage)) {
      return;
    }

    final PagingState<int, AppNotification> baseState = clearPage
        ? PagingState<int, AppNotification>()
        : pagingState;
    pagingState = baseState.copyWith(isLoading: true, error: null);

    final int nextKey = (baseState.keys?.last ?? -1) + 1;
    RequestResult reqResult = await _apiClient.getNotificationList(
      nextKey,
      size: _pageSize,
    );
    if (reqResult is RequestFail) {
      pagingState = pagingState.copyWith(
        isLoading: false,
        error: reqResult.serverFail,
      );

      return;
    }

    List<AppNotification> notiList =
        (reqResult as RequestSuccess<List<AppNotification>>).data;
    pagingState = pagingState.copyWith(
      isLoading: false,
      pages: [...baseState.pages ?? [], notiList],
      keys: [...baseState.keys ?? [], nextKey],
      hasNextPage: notiList.isNotEmpty,
    );
  }

  Future<void> fetchSubscriptions() async {
    final result = await _apiClient.getSubscriptions();
    if (result is RequestSuccess<List<NotificationSubscription>>) {
      subscriptions.assignAll(result.data);
    }
  }

  Future<void> openNotificationSettings() async {
    await Get.toNamed(Routes.NOTIFICATION_SETTINGS);
    await fetchSubscriptions();
  }

  Future<void> retryNotificationList() async {
    await fetchNotificationList(clearPage: notifications.isEmpty);
    await _ensureSelectedTabHasVisibleItems();
  }

  Future<void> openSelectedConditionSettings() async {
    final mode = switch (selectedTab.value) {
      NotificationTab.event => NotificationFilterMode.event,
      NotificationTab.job => NotificationFilterMode.job,
      NotificationTab.all => null,
    };

    if (mode == null) {
      await openNotificationSettings();
      return;
    }

    final result = await Get.toNamed(
      Routes.NOTIFICATION_FILTER,
      arguments: mode,
    );
    if (result == true) {
      await fetchSubscriptions();
    }
  }

  Future<bool> markAllAsRead() async {
    RequestResult rst = await _apiClient.readAllNotification();
    bool success =
        !(rst is RequestFail || (rst is RequestSuccess && rst.data == false));

    return success;
  }

  Future<bool> deleteNotification(int id) async {
    RequestResult rst = await _apiClient.deleteNotification(id);
    bool success =
        !(rst is RequestFail || (rst is RequestSuccess && rst.data == false));
    if (!success) return false;

    final currentPages = pagingState.pages ?? <List<AppNotification>>[];
    final currentKeys = pagingState.keys ?? <int>[];

    final List<List<AppNotification>> updatedPages = [];
    final List<int> updatedKeys = [];

    for (int i = 0; i < currentPages.length; i++) {
      final List<AppNotification> page = currentPages[i]
          .where((n) => n.id != id)
          .toList();

      if (page.isNotEmpty) {
        updatedPages.add(page);
        updatedKeys.add(currentKeys[i]);
      }
    }

    pagingState = pagingState.copyWith(pages: updatedPages, keys: updatedKeys);

    return success;
  }

  Future<void> _ensureSelectedTabHasVisibleItems() async {
    if (selectedTab.value == NotificationTab.all) return;
    if (isResolvingFilteredTab.value) return;

    isResolvingFilteredTab.value = true;
    try {
      while (pagingState.isLoading) {
        await Future<void>.delayed(const Duration(milliseconds: 80));
      }

      while (filteredNotifications.isEmpty &&
          hasNextPage &&
          pageError == null) {
        await fetchNotificationList();
      }
    } finally {
      isResolvingFilteredTab.value = false;
    }
  }

  bool _isEventNotification(AppNotification notification) {
    return notification.event != null ||
        notification.type.startsWith('EVENT_') ||
        notification.type.startsWith('RECRUITMENT_');
  }

  bool _isJobNotification(AppNotification notification) {
    return notification.jobPosting != null ||
        notification.type.startsWith('JOB_');
  }
}
