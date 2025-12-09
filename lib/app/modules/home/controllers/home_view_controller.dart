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
import 'package:duty_it/app/modules/home/controllers/bookmark_modal_controller.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/modal/bookmark_bottom_modal.dart';
import 'package:duty_it/app/modules/home/widgets/modal/sorting_bottom_modal.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/event/app_event_service.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
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

  final Lock _fetchPageLock = Lock();
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
  }

  Future<void> checkNewNotification() async {
    if (!Get.find<AuthService>().isLoggined()) {
      _hasNewNotification.value = false;
      return;
    }

    var api = Get.find<ApiClient>();
    RequestResult<List<AppNotification>> result = await api.getNotificationList(
      0,
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
    await _fetchPageLock.synchronized(() async {
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

      for (var category in categories) {
        types.add(EventType.getByDisplayName(category));
      }

      String? pageKey = pagingState.keys?.last;
      int? hostId = sfService.filter.host?.id;

      if (!onlyFinishedMode) {
        if (pageKey == null &&
            sfService.filter.showEnded &&
            (pagingState.keys?.isNotEmpty ?? false)) {
          onlyFinishedMode = true;
        }
      }

      // request

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
            isLoading: false,
            keys: [...pagingState.keys ?? [], pageInfo.nextCursor],
            pages: [
              ...pagingState.pages ?? [],
              List<EventCard>.generate(
                events.length,
                (i) => EventCard(eventRx: Rx(events[i])),
              ),
            ],
            hasNextPage: hasNext,
          );
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
    });
  }

  void showSortingBottomModal() {
    Get.put<SortingModalController>(SortingModalController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SortingBottomModal(),
    ).whenComplete(() => Get.delete<SortingModalController>());
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
      Get.put<BookmarkModalController>(
        BookmarkModalController(eventRx: eventRx),
      );
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => BookmarkBottomModal(),
      ).whenComplete(() => Get.delete<BookmarkModalController>());
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
