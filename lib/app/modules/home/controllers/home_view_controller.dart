import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/modal/bookmark_bottom_modal.dart';
import 'package:duty_it/app/modules/home/widgets/modal/sorting_bottom_modal.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/services/event/app_event_service.dart';
import 'package:duty_it/app/services/event/events/event_bookmark_event.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/no_calendar_permission_modal.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
  static const double _pullToRefreshTriggerFraction = 0.25;

  final HomeViewCache _cache = HomeViewCache();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ScrollController scrollController = ScrollController();

  bool loadEventListFromCache = true;

  AppSettingsService get _settingsService => Get.find<AppSettingsService>();
  AppEventService get _eventService => Get.find<AppEventService>();

  final Rx<PagingState<String?, EventCard>> _pagingState =
      PagingState<String?, EventCard>(isLoading: true).obs;
  PagingState<String?, EventCard> get pagingState => _pagingState.value;
  set pagingState(state) => _pagingState.value = state;

  final Rx<HomeTab> _selectedTab = HomeTab.event.obs;
  set selectedTab(HomeTab tab) {
    if (tab != HomeTab.event && !Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }
    _selectedTab.value = tab;
  }

  HomeTab get selectedTab => _selectedTab.value;

  final Rx<EventSortingType> _sortingType = Rx(EventSortingType.latest);
  EventSortingType get sortingType => _sortingType.value;
  set sortingType(EventSortingType type) {
    _sortingType.value = type;
    _settingsService.eventSortingType.value = type.name;
  }

  final TextEditingController searchTextEditingController =
      TextEditingController();
  final RxString searchQuery = RxString('');

  final Lock _pageFetchLock = Lock();
  bool onlyFinishedMode = false;

  final RxBool _hasNewNotification = RxBool(false);
  bool get hasNewNotification => _hasNewNotification.value;
  final Rx<RefreshIndicatorStatus?> _refreshIndicatorStatus =
      Rx<RefreshIndicatorStatus?>(null);
  final RxBool _isPullToRefreshing = false.obs;
  final RxDouble _pullToRefreshProgress = 0.0.obs;
  double get pullToRefreshProgress => _pullToRefreshProgress.value;
  double _pullDragOffset = 0.0;

  bool get shouldShowRefreshIndicator {
    if (_isPullToRefreshing.value) return true;

    switch (_refreshIndicatorStatus.value) {
      case RefreshIndicatorStatus.drag:
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.snap:
        return true;
      case RefreshIndicatorStatus.refresh:
      case RefreshIndicatorStatus.done:
      case RefreshIndicatorStatus.canceled:
      case null:
        return false;
    }
  }

  bool get isPullToRefreshing => _isPullToRefreshing.value;

  WidgetsBinding get binding => WidgetsBinding.instance;
  bool get isForeground => binding.lifecycleState == AppLifecycleState.resumed;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    _sortingType.value = EventSortingType.fromName(
      _settingsService.eventSortingType.value,
    );

    searchTextEditingController.addListener(
      () => searchQuery.value = searchTextEditingController.text.trim(),
    );

    debounce(searchQuery, (v) async {
      analytics.logSearch(searchTerm: searchQuery.value);
      await fetchNextPage(clearPage: true);
    }, time: Duration(milliseconds: 500));

    ever(_selectedTab, (_) async {
      HapticFeedback.lightImpact();
      await fetchNextPage(clearPage: true);
    });

    ever(
      Get.find<SearchFilterService>().filterRx,
      (v) => fetchNextPage(clearPage: true),
    );

    ever(_sortingType, (v) => fetchNextPage(clearPage: true));

    checkNewNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNextPage(clearPage: true);
    });
  }

  @override
  void onClose() {
    searchTextEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void updateRefreshIndicatorStatus(RefreshIndicatorStatus? status) {
    _refreshIndicatorStatus.value = status;

    switch (status) {
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.snap:
      case RefreshIndicatorStatus.refresh:
        _pullToRefreshProgress.value = 1.0;
      case RefreshIndicatorStatus.done:
      case RefreshIndicatorStatus.canceled:
      case null:
        _resetPullToRefreshProgress();
      case RefreshIndicatorStatus.drag:
        break;
    }
  }

  Future<void> onPullToRefresh() async {
    _isPullToRefreshing.value = true;
    _pullToRefreshProgress.value = 1.0;
    try {
      await fetchNextPage(clearPage: true);
      await checkNewNotification();
    } finally {
      _isPullToRefreshing.value = false;
      _refreshIndicatorStatus.value = null;
      _resetPullToRefreshProgress();
    }
  }

  bool onPullToRefreshScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    final status = _refreshIndicatorStatus.value;
    final isTrackingPull =
        status == RefreshIndicatorStatus.drag ||
        status == RefreshIndicatorStatus.armed;

    if (notification is ScrollStartNotification &&
        notification.dragDetails != null &&
        notification.metrics.extentBefore == 0.0) {
      _pullDragOffset = 0.0;
      _pullToRefreshProgress.value = 0.0;
      return false;
    }

    if (!isTrackingPull) return false;

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axisDirection == AxisDirection.down) {
        _pullDragOffset -= notification.scrollDelta ?? 0.0;
      } else if (notification.metrics.axisDirection == AxisDirection.up) {
        _pullDragOffset += notification.scrollDelta ?? 0.0;
      }
      _updatePullToRefreshProgress(notification.metrics.viewportDimension);
    } else if (notification is OverscrollNotification) {
      if (notification.metrics.axisDirection == AxisDirection.down) {
        _pullDragOffset -= notification.overscroll;
      } else if (notification.metrics.axisDirection == AxisDirection.up) {
        _pullDragOffset += notification.overscroll;
      }
      _updatePullToRefreshProgress(notification.metrics.viewportDimension);
    }

    return false;
  }

  void _updatePullToRefreshProgress(double viewportDimension) {
    if (viewportDimension <= 0) return;

    final progress =
        (_pullDragOffset / (viewportDimension * _pullToRefreshTriggerFraction))
            .clamp(0.0, 1.0)
            .toDouble();

    _pullToRefreshProgress.value = progress;
  }

  void _resetPullToRefreshProgress() {
    _pullDragOffset = 0.0;
    _pullToRefreshProgress.value = 0.0;
  }

  Future<void> checkNewNotification() async {
    if (!Get.find<AuthService>().isLoggined()) {
      _hasNewNotification.value = false;
      return;
    }

    var api = Get.find<ApiClient>();
    RequestResult<List<AppNotification>> result = await api.getNotificationList(
      0,
      size: 1,
    );
    if (result is RequestFail) return;

    List<AppNotification> notiList = (result as RequestSuccess).data;
    if (notiList.isEmpty) {
      _hasNewNotification.value = false;
      return;
    }

    AppNotification noti = notiList.first;
    _hasNewNotification.value = !noti.isRead;
  }

  void scrollUpEventList() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> fetchNextPage({bool clearPage = false}) async {
    if (!clearPage && pagingState.isLoading) return;
    await _pageFetchLock.synchronized(
      () async => await _fetchNextPage(clearPage: clearPage),
    );
  }

  Future<void> _fetchNextPage({bool clearPage = false}) async {
    final loadCache = loadEventListFromCache;
    loadEventListFromCache = false;

    SearchFilterService sfService = Get.find<SearchFilterService>();
    final previousPagingState = pagingState;
    final preserveVisibleItems = clearPage && _isPullToRefreshing.value;

    // Update paging state
    if (clearPage) onlyFinishedMode = false;
    if (preserveVisibleItems) {
      pagingState = pagingState.copyWith(error: null, isLoading: false);
    } else {
      pagingState = pagingState.copyWith(
        isLoading: true,
        error: null,
        keys: clearPage ? null : const Omit(),
        pages: clearPage ? null : const Omit(),
      );
    }

    // set params
    const int size = 5;
    var filter = sfService.filter;
    List<String> categories = filter.categories.toList();
    List<EventType> types = [];
    final List<String?> currentKeys = clearPage
        ? <String?>[]
        : List<String?>.from(pagingState.keys ?? const <String?>[]);
    final List<List<EventCard>> currentPages = clearPage
        ? <List<EventCard>>[]
        : List<List<EventCard>>.from(
            pagingState.pages ?? const <List<EventCard>>[],
          );
    String? pageKey = currentKeys.isEmpty ? null : currentKeys.last;
    int? hostId = sfService.filter.host?.id;

    for (var category in categories) {
      types.add(EventType.getByDisplayName(category));
    }

    if (!onlyFinishedMode) {
      if (pageKey == null &&
          sfService.filter.showEnded &&
          currentKeys.isNotEmpty) {
        onlyFinishedMode = true;
      }
    }

    if (loadCache) {
      try {
        var cachedResponse = _cache.getEvents();
        if (cachedResponse != null) {
          pagingState = pagingState.copyWith(
            keys: [
              ...pagingState.keys ?? [],
              cachedResponse.pageInfo.nextCursor,
            ],
            pages: [
              List<EventCard>.generate(
                cachedResponse.events.length,
                (i) => EventCard(eventRx: Rx(cachedResponse.events[i])),
              ),
            ],
            hasNextPage: false,
            isLoading: true,
          );
        }
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(e, s);
      }
    }

    // request
    FirebaseAnalytics.instance.logEvent(
      name: 'fetch_events_page',
      parameters: {'clear_page': "$clearPage"},
    );
    bool hasError = false;
    try {
      var apiClient = Get.find<ApiClient>();
      var reqResult = await apiClient.getEvents(
        finished: onlyFinishedMode,
        bookmarked: selectedTab == HomeTab.bookmark,
        cursor: pageKey,
        size: size,
        field: sortingType.field,
        searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
        hostId: hostId,
        types: types,
      );
      if (reqResult is RequestSuccess) {
        EventsResponse response =
            (reqResult as RequestSuccess<EventsResponse>).data;
        var pageInfo = response.pageInfo;
        var events = response.events;

        bool hasNext;
        if (sfService.filter.showEnded) {
          if (onlyFinishedMode) {
            hasNext = pageInfo.hasNext;
          } else {
            hasNext = true;
          }
        } else {
          hasNext = pageInfo.hasNext;
        }

        pagingState = pagingState.copyWith(
          keys: [...(!loadCache ? currentKeys : []), pageInfo.nextCursor],
          pages: [
            ...(!loadCache ? currentPages : []),
            List<EventCard>.generate(
              events.length,
              (i) => EventCard(eventRx: Rx(events[i])),
            ),
          ],
          hasNextPage: hasNext,
        );

        if (clearPage &&
            searchQuery.isEmpty &&
            _selectedTab.value == HomeTab.event) {
          _cache.saveEvents(response);
        }
      } else {
        hasError = true;
        if (kDebugMode) {
          AppUtils.showSnackBar(
            '이벤트 목록을 불러오지 못했습니다: ${(reqResult as RequestFail).serverFail?.message ?? ""}',
          );
        }
      }
    } catch (ex, st) {
      hasError = true;
      if (kDebugMode) {
        print(ex.toString() + st.toString());
      }
      FirebaseCrashlytics.instance.recordError(ex, st);
    } finally {
      if (hasError) {
        if (preserveVisibleItems) {
          pagingState = previousPagingState.copyWith(
            error: previousPagingState.error,
          );
        } else {
          pagingState = pagingState.copyWith(
            keys: clearPage ? [] : Omit(),
            pages: clearPage ? [] : Omit(),
            error: true,
          );
        }
      }
      pagingState = pagingState.copyWith(isLoading: false);
    }
  }

  void showSortingBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SortingBottomModal(),
    );
  }

  Future<void> onBookmarkButtonClick(Rx<Event> eventRx) async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    var event = eventRx.value;
    final initialUser = await _ensureAppUserLoaded();
    if (initialUser == null) return;

    analytics.logEvent(
      name: 'event_bookmark_button_click',
      parameters: {
        'event_id': event.id.toString(),
        'currentState': event.isBookmarked.toString(),
      },
    );

    if (!event.isBookmarked) {
      await showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => BookmarkBottomModal(eventRx: eventRx),
      );
    } else {
      eventRx.value = event.copyWith(isBookmarked: !event.isBookmarked);

      eventRx.value = event.copyWith(isBookmarked: await toggleBookmark(event));
    }

    var user = await _ensureAppUserLoaded();
    if (user == null) return;
    var calendarService = Get.find<CalendarService>();
    if (eventRx.value.isBookmarked && user.autoAddBookmarkToCalendar) {
      var result = await calendarService.requestPermission();
      if (!result) {
        AppUtils.showSnackBar(
          "권한이 없어서 캘린더에 추가하지 못했어요.",
          mainButton: Row(
            spacing: 15,
            children: [
              AppNormalButton(
                text: '설정하기',
                width: 100,
                onTap: () async {
                  Get.back();
                  showModalBottomSheet(
                    context: Get.context!,
                    isDismissible: true,
                    useSafeArea: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) => NoCalendarPermissionModal(),
                  );
                },
              ),
            ],
          ),
        );
        return;
      }

      DateTime now = DateTime.now();
      DateTime start = event.startAt ?? now;
      DateTime end = event.endAt ?? start;

      await Get.find<CalendarService>().addEvent(
        title: event.title,
        startDate: start,
        endDate: end,
        id: event.id.toString(),
        description: "${event.host.name}\n${event.uri}",
      );
    } else if (!eventRx.value.isBookmarked) {
      if (await calendarService.checkPermission()) {
        await calendarService.removeEvent(event.id.toString());
      }
    }
  }

  Future<bool> toggleBookmark(Event event) async {
    bool isBookmarked = event.isBookmarked;

    var client = Get.find<ApiClient>();
    var result = await client.toggleBookmark(event.id);
    if (result is RequestSuccess) {
      isBookmarked = (result as RequestSuccess<bool>).data;
      if (isBookmarked) {
        _eventService.fire(EventBookmarkEvent());

        analytics.logAddToWishlist(
          items: [
            AnalyticsEventItem(
              itemId: event.id.toString(),
              itemName: event.title,
              itemBrand: event.host.name,
            ),
          ],
        );
      } else {
        analytics.logEvent(
          name: 'unbookmark',
          parameters: {'event_id': event.id.toString()},
        );
      }
    } else {
      var reqFail = result as RequestFail;
      AppUtils.showSnackBar(reqFail.serverFail?.message ?? '북마크를 수정하지 못했습니다.');
    }

    return isBookmarked;
  }

  Future<AppUser?> _ensureAppUserLoaded() async {
    final user = await Get.find<AuthService>().ensureAppUserLoaded();
    if (user != null) return user;

    AppUtils.showSnackBar('사용자 정보를 불러오지 못했어요. 다시 시도해 주세요.');
    return null;
  }

  Future<void> openNotificationsPage() async {
    await Get.toNamed(Routes.NOTIFICATIONS);
    checkNewNotification();
  }
}
