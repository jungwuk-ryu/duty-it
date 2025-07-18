import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:myapp/app/modules/home/widgets/event_card.dart';

enum HomeTab { event, bookmark }

class HomeViewController extends GetxController {
  late final PagingController _pagingController;
  get pagingController => _pagingController;

  final Rx<HomeTab> _selectedTab = HomeTab.event.obs;
  set selectedTab(HomeTab tab) => _selectedTab.value = tab;
  HomeTab get selectedTab => _selectedTab.value;

  @override
  void onInit() {
    super.onInit();
    _pagingController = PagingController<int, EventCard>(
      getNextPageKey: (state) => ((state.keys?.last ?? 0) + 1),
      fetchPage: (key) => List.generate(10, (index) => EventCard()),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
