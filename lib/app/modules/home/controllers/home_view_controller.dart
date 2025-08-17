import 'package:duty_it/app/core/events/event_bookmark_event.dart';
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

  void fetchNextPage() {
    pagingState = pagingState.copyWith(isLoading: true, error: null);

    int nextKey = 0;
    if (!(pagingState.keys == null || pagingState.keys!.isEmpty))
      nextKey = pagingState.keys!.last;
    nextKey += 1;

    pagingState = pagingState.copyWith(
      isLoading: false,
      keys: [...pagingState.keys ?? [], nextKey],
      pages: [
        ...pagingState.pages ?? [],
        List<EventCard>.generate(10, (index) => EventCard()),
      ],
    );
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

  void bookmarkTest() {
    _eventService.fire(EventBookmarkEvent());
  }
}
