import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/event/events/event_bookmark_event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/modal/bookmark_bottom_modal.dart';
import 'package:duty_it/app/modules/home/widgets/modal/sorting_bottom_modal.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/event/app_event_service.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
  static final String storageBoxName = "homeContainer";
  static final String listCacheKey = "event_list";
  static final String urlCacheKey = "request_url";
  static final String lastUpdateCacheKey = "last_update";
  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ScrollController scrollController = ScrollController();

  AppSettingsService get _settingsService => Get.find<AppSettingsService>();
  AppEventService get _eventService => Get.find<AppEventService>();

  final Rx<PagingState<String?, EventCard>> _pagingState =
      PagingState<String?, EventCard>().obs;
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

  EventSortingType get sortingType => _settingsService.eventSortingType;

  final TextEditingController searchTextEditingController =
      TextEditingController();
  final RxString searchQuery = RxString('');

  final Lock _pageFetchLock = Lock();
  bool onlyFinishedMode = false;

  final RxBool _hasNewNotification = RxBool(false);
  bool get hasNewNotification => _hasNewNotification.value;

  WidgetsBinding get binding => WidgetsBinding.instance;
  bool get isForeground => binding.lifecycleState == AppLifecycleState.resumed;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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

    ever(
      _settingsService.eventSortingTypeSetting.rxValue,
      (v) => fetchNextPage(clearPage: true),
    );

    checkNewNotification();
    fetchNextPage(clearPage: true, loadCache: true);
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

  Future<void> fetchNextPage({bool clearPage = false, bool loadCache = false}) async {
    if (!clearPage && pagingState.isLoading) return;
    await _pageFetchLock.synchronized(() async => await _fetchNextPage(clearPage: clearPage, loadCache: loadCache));
  }

  Future<void> _fetchNextPage({bool clearPage = false, bool loadCache = false}) async {
    SearchFilterService sfService = Get.find<SearchFilterService>();

    // Update paging state
    if (clearPage) onlyFinishedMode = false;
    pagingState = pagingState.copyWith(
      isLoading: true,
      error: null,
      keys: clearPage ? null : const Omit(),
      pages: clearPage ? null : const Omit(),
    );


    // set params
    const int size = 5;
    var filter = sfService.filter;
    List<String> categories = filter.categories.toList();
    List<EventType> types = [];
    String? pageKey = pagingState.keys?.last;
    int? hostId = sfService.filter.host?.id;

    for (var category in categories) {
      types.add(EventType.getByDisplayName(category));
    }

    if (!onlyFinishedMode) {
      if (pageKey == null &&
          sfService.filter.showEnded &&
          (pagingState.keys?.isNotEmpty ?? false)) {
        onlyFinishedMode = true;
      }
    }

    GetStorage box = GetStorage(storageBoxName);

    if (loadCache) {
      try {
        Map? listCache = box.read(listCacheKey);
        int? lastUpdateMills = box.read(lastUpdateCacheKey);
        DateTime? lastUpdate = lastUpdateMills != null ? DateTime.fromMillisecondsSinceEpoch(lastUpdateMills) : null;

        if (lastUpdate != null && DateTime.now().difference(lastUpdate).inDays < 7 && listCache != null) {
          EventsResponse cachedResponse = EventsResponse.fromJson(
            Map<String, dynamic>.from(listCache),
          );
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
    FirebaseAnalytics.instance.logEvent(name: 'fetch_events_page', parameters: {'clear_page': "$clearPage"});
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
          keys: [...(!loadCache ? (pagingState.keys ?? []) : []), pageInfo.nextCursor],
          pages: [
            ...(!loadCache ? (pagingState.pages ?? []) : []),
            List<EventCard>.generate(
              events.length,
              (i) => EventCard(eventRx: Rx(events[i])),
            ),
          ],
          hasNextPage: hasNext,
        );

        if (clearPage && searchQuery.isEmpty) {
          box.write(listCacheKey, response.toJson());
          box.write(urlCacheKey, response.reqUrl);
          box.write(lastUpdateCacheKey, DateTime.now().millisecondsSinceEpoch);
        }
      } else {
        var fail = reqResult as RequestFail;
        if (kDebugMode) {
          AppUtils.showSnackBar(
            '이벤트 목록을 불러오지 못했습니다: ${fail.serverFail?.message ?? ""}',
          );
        }
      }
    } finally {
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
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    var appSettings = Get.find<AppSettingsService>();
    var event = eventRx.value;

    analytics.logEvent(
      name: 'event_bookmark_button_click',
      parameters: {
        'event_id': event.id.toString(),
        'currentState': event.isBookmarked.toString(),
      },
    );

    if (!event.isBookmarked && !appSettings.dontShowAutoAddModal.value) {
      
      showModalBottomSheet(
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

  Future<void> openNotificationsPage() async {
    await Get.toNamed(Routes.NOTIFICATIONS);
    checkNewNotification();
  }
}
