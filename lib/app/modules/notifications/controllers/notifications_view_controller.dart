import 'dart:async';

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
  bool _isMarkingAllAsRead = false;
  int _listGeneration = 0;
  int _subscriptionsGeneration = 0;
  static const int _pageSize = 20;

  final Rx<NotificationTab> selectedTab = NotificationTab.all.obs;
  final RxList<NotificationSubscription> subscriptions =
      <NotificationSubscription>[].obs;

  final Rx<PagingState<int, AppNotification>> _pagingState =
      PagingState<int, AppNotification>().obs;
  PagingState<int, AppNotification> get pagingState => _pagingState.value;
  set pagingState(PagingState<int, AppNotification> state) =>
      _pagingState.value = state;

  @override
  void onInit() {
    super.onInit();

    fetchNotificationList();
    fetchSubscriptions();
  }

  Iterable<AppNotification> _visibleItems(List<List<AppNotification>>? pages) {
    final items = (pages ?? const <List<AppNotification>>[]).expand((p) => p);
    return switch (selectedTab.value) {
      NotificationTab.all => items,
      NotificationTab.event => items.where(_isEventNotification),
      NotificationTab.job => items.where(_isJobNotification),
    };
  }

  List<AppNotification> get filteredNotifications =>
      _visibleItems(pagingState.pages).toList(growable: false);

  bool get isInitialLoading =>
      pagingState.isLoading && (pagingState.pages?.isEmpty ?? true);

  bool get isLoadingMore =>
      pagingState.isLoading && (pagingState.pages?.isNotEmpty ?? false);

  Object? get pageError => pagingState.error;

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
    if (tab != NotificationTab.all &&
        _visibleItems(pagingState.pages).isEmpty) {
      fetchNotificationList();
    }
  }

  Future<void> refreshNotificationList() async {
    await Future.wait([_fetchPages(refresh: true), fetchSubscriptions()]);
  }

  Future<void> fetchNotificationList() => _fetchPages();

  Future<void> retryNotificationList() =>
      pageError == null ? Future.value() : _fetchPages(retry: true);

  Future<void> _fetchPages({bool refresh = false, bool retry = false}) async {
    if (isClosed) return;
    if (!refresh &&
        (pagingState.isLoading ||
            !hasNextPage ||
            (pageError != null && !retry))) {
      return;
    }

    final generation = ++_listGeneration;
    pagingState = refresh
        ? PagingState<int, AppNotification>(isLoading: true)
        : pagingState.copyWith(isLoading: true, error: null);

    while (true) {
      final nextKey = (pagingState.keys?.lastOrNull ?? -1) + 1;
      final RequestResult<List<AppNotification>> result;
      try {
        result = await _apiClient.getNotificationList(nextKey, size: _pageSize);
      } catch (error) {
        if (!isClosed && generation == _listGeneration) {
          pagingState = pagingState.copyWith(isLoading: false, error: error);
        }
        return;
      }
      if (isClosed || generation != _listGeneration) return;

      if (result is RequestFail) {
        pagingState = pagingState.copyWith(isLoading: false, error: result);
        return;
      }

      final items = (result as RequestSuccess<List<AppNotification>>).data;
      final pages = [...?pagingState.pages, items];
      final hasNext = items.isNotEmpty;
      final needsMore =
          hasNext &&
          selectedTab.value != NotificationTab.all &&
          _visibleItems(pages).isEmpty;
      pagingState = pagingState.copyWith(
        isLoading: needsMore,
        pages: pages,
        keys: [...?pagingState.keys, nextKey],
        hasNextPage: hasNext,
      );
      unawaited(_markAllAsReadOnce());
      if (!needsMore) return;
    }
  }

  Future<void> fetchSubscriptions() async {
    if (isClosed) return;
    final generation = ++_subscriptionsGeneration;
    final result = await _apiClient.getSubscriptions();
    if (!isClosed &&
        generation == _subscriptionsGeneration &&
        result is RequestSuccess<List<NotificationSubscription>>) {
      subscriptions.assignAll(result.data);
    }
  }

  Future<void> openNotificationSettings() async {
    await Get.toNamed(Routes.NOTIFICATION_SETTINGS);
    await fetchSubscriptions();
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

  Future<void> _markAllAsReadOnce() async {
    if (_didMarkAllAsRead || _isMarkingAllAsRead) return;
    _isMarkingAllAsRead = true;
    try {
      final result = await _apiClient.readAllNotification();
      _didMarkAllAsRead = result is RequestSuccess<bool> && result.data;
    } finally {
      _isMarkingAllAsRead = false;
    }
  }

  Future<bool> deleteNotification(int id) async {
    RequestResult rst = await _apiClient.deleteNotification(id);
    bool success =
        !(rst is RequestFail || (rst is RequestSuccess && rst.data == false));
    if (!success || isClosed) return false;

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
