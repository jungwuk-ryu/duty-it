import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/events/event_bookmark_event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/event.dart';
import 'package:duty_it/app/models/event_type.dart';
import 'package:duty_it/app/modules/home/controllers/bookmark_modal_controller.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/modal/bookmark_bottom_modal.dart';
import 'package:duty_it/app/modules/home/widgets/modal/sorting_bottom_modal.dart';
import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_event_service.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController with WidgetsBindingObserver {
  AppSettingsService get _settingsService => Get.find<AppSettingsService>();
  AppEventService get _eventService => Get.find<AppEventService>();

  final Rx<PagingState<int, EventCard>> _pagingState =
      PagingState<int, EventCard>().obs;
  PagingState<int, EventCard> get pagingState => _pagingState.value;
  set pagingState(state) => _pagingState.value = state;

  final Rx<HomeTab> _selectedTab = HomeTab.event.obs;
  set selectedTab(HomeTab tab) => _selectedTab.value = tab;
  HomeTab get selectedTab => _selectedTab.value;

  EventSortingType get sortingType => _settingsService.eventSortingType;

  final TextEditingController searchTextEditingController =
      TextEditingController();
  final RxString searchQuery = RxString('');

  final Lock _fetchPageLock = Lock();

  final RxBool _hasNewNotification = RxBool(false);
  bool get hasNewNotification => _hasNewNotification.value;

  WidgetsBinding get binding => WidgetsBinding.instance;
  bool get isForeground => binding.lifecycleState == AppLifecycleState.resumed;

  Timer? _newNotiTimer;

  @override
  void onInit() {
    super.onInit();

    searchTextEditingController.addListener(
      () => searchQuery.value = searchTextEditingController.text.trim(),
    );

    debounce(
      searchQuery,
      (v) async => await fetchNextPage(clearPage: true),
      time: Duration(milliseconds: 500),
    );

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (isForeground) {
      _startNewNotiTimer();
    } else {
      _stopNewNotiTimer();
    }
  }

  void _startNewNotiTimer() {
    _stopNewNotiTimer();
    _newNotiTimer = Timer.periodic(
      Duration(seconds: 10),
      (_) => checkNewNotification(),
    );
  }

  void _stopNewNotiTimer() {
    _newNotiTimer?.cancel();
  }

  Future<void> checkNewNotification() async {
    var repo = Get.find<NotificationRepository>();
    List<String> list = await repo.getIdList();
    if (list.isEmpty) {
      _hasNewNotification.value = false;
      return;
    }

    var noti = await repo.getNotificationById(list.first);
    if (noti == null) {
      _hasNewNotification.value = false;
      return;
    }

    _hasNewNotification.value = !noti.read;
  }

  Future<void> fetchNextPage({bool clearPage = false}) async {
    await _fetchPageLock.synchronized(() async {
      SearchFilterService sfService = Get.find<SearchFilterService>();

      // Update paging state
      pagingState = pagingState.copyWith(
        isLoading: true,
        error: null,
        keys: clearPage ? [] : const Omit(),
        pages: clearPage ? [] : const Omit(),
      );

      // find next key
      int nextKey = 0;
      if (!clearPage &&
          !(pagingState.keys == null || pagingState.keys!.isEmpty)) {
        nextKey = pagingState.keys!.last + 1;
      }

      // set params
      const int size = 10;
      var filter = sfService.filter;
      List<String> categories = filter.categories.toList();
      List<EventType> types = [];

      for (var category in categories) {
        types.add(EventType.getByDisplayName(category));
      }

      int? hostId = sfService.filter.host?.id;
      bool includeFinished = sfService.filter.showEnded;

      // request

      try {
        var apiClient = Get.find<ApiClient>();
        var reqResult = await apiClient.getEvents(
          isApproved: true,
          includeFinished: includeFinished,
          isBookmarked: selectedTab == HomeTab.bookmark,
          page: nextKey,
          size: size,
          sortDirection: sortingType.sortDirection,
          field: sortingType.field,
          searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
          hostId: hostId,
          types: types,
        );
        if (reqResult is RequestSuccess) {
          var events = (reqResult as RequestSuccess<List<Event>>).data;

          pagingState = pagingState.copyWith(
            isLoading: false,
            keys: [...pagingState.keys ?? [], nextKey],
            pages: [
              ...pagingState.pages ?? [],
              List<EventCard>.generate(
                events.length,
                (i) => EventCard(eventRx: Rx(events[i])),
              ),
            ],
            hasNextPage: events.length >= size,
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
    var appSettings = Get.find<AppSettingsService>();
    if (!eventRx.value.isBookmarked &&
        !appSettings.dontShowAutoAddModal.value) {
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
      eventRx.value = eventRx.value.copyWith(
        isBookmarked: await bookmark(eventRx.value),
      );
    }
  }

  Future<bool> bookmark(Event event) async {
    bool isBookmarked = event.isBookmarked;
    var client = Get.find<ApiClient>();
    var result = await client.toggleBookmark(event.id);
    if (result is RequestSuccess) {
      isBookmarked = (result as RequestSuccess<bool>).data;
      if (isBookmarked) {
        _eventService.fire(EventBookmarkEvent());
      }
    } else {
      var reqFail = result as RequestFail;
      AppUtils.showSnackBar(reqFail.serverFail?.message ?? '북마크를 수정하지 못했습니다.');
    }

    return isBookmarked;
  }

  void openNotificationsPage() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }
}
