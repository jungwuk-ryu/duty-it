import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:get/get.dart';

class SortingModalController extends GetxController {
  HomeViewController get _homeController => Get.find<HomeViewController>();

  EventSortingType get selectedType => _homeController.sortingType;

  void selectTypeAndClose(EventSortingType type) {
    _homeController.sortingType = type;
    Get.back();
  }
}
