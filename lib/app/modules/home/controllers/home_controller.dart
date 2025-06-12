import 'package:get/get.dart';
import 'package:myapp/app/modules/home/widgets/event_card.dart';

enum HomeTab { event, bookmark }

class HomeController extends GetxController {
  //TODO: Implement HomeController

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
}
