import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:get/get.dart';

class SortingModalController extends GetxController {
  HomeViewController get _homeController => Get.find<HomeViewController>();
  
  Rx<EventSortingType> selectedType = Rx(Get.find<HomeViewController>().sortingType);

  void applyAndClose() {
    _homeController.sortingType = selectedType.value;
    Get.back();
  }
}