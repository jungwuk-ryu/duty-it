import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/events/event_bookmark_event.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/models/event.dart';
import 'package:duty_it/app/models/sort_direction.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/modal/sorting_bottom_modal.dart';
import 'package:duty_it/app/services/app_event_service.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();

    searchTextEditingController.addListener(
      () => searchQuery.value = searchTextEditingController.text.trim(),
    );
    debounce(
      searchQuery,
      (v) => fetchNextPage(clearPage: true),
      time: Duration(milliseconds: 500),
    );
  }

  Future<void> fetchNextPage({bool clearPage = false}) async {
    pagingState = pagingState.copyWith(isLoading: true, error: null);

    int nextKey = 0;
    if (!clearPage &&
        !(pagingState.keys == null || pagingState.keys!.isEmpty)) {
      nextKey = (pagingState.keys?.last ?? -1) + 1;
    }

    pagingState = pagingState.copyWith(
      isLoading: true,
      keys: clearPage ? [] : const Omit(),
      pages: clearPage ? [] : const Omit(),
    );

    const int size = 10;

    try {
      var apiClient = Get.find<ApiClient>();
      var reqResult = await apiClient.getEvents(
        isApproved: true,
        page: nextKey,
        size: size,
        sortDirection: SortDirection.DESC,
        field: 'ID',
        searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
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
        AppUtils.showSnackBar('이벤트 목록을 불러오지 못했습니다: ${fail.serverFail?.message ?? ""}');
      }
    } finally {
      pagingState = pagingState.copyWith(isLoading: false);
    }
  }

  void showSortingBottomModal() {
    Get.put<SortingModalController>(SortingModalController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SortingBottomModal(),
    ).whenComplete(() => Get.delete<SortingModalController>());
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
}
