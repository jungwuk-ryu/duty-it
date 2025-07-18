import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
  final Rx<PagingState<int, EventCard>> _pagingState =
      PagingState<int, EventCard>().obs;
  PagingState<int, EventCard> get pagingState => _pagingState.value;
  set pagingState(state) => _pagingState.value = state;

  final Rx<HomeTab> _selectedTab = HomeTab.event.obs;
  set selectedTab(HomeTab tab) => _selectedTab.value = tab;
  HomeTab get selectedTab => _selectedTab.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchNextPage() {
    pagingState = pagingState.copyWith(isLoading: true, error: null);

    int nextKey = 0;
    if (!(pagingState.keys == null || pagingState.keys!.isEmpty)) nextKey = pagingState.keys!.last;
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
}
