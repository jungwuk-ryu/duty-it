import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/services/search_filter_service.dart';
import 'package:get/get.dart';
import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';

import '../controllers/main_view_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchFilterService>(SearchFilterService());
    Get.lazyPut<MainViewController>(() => MainViewController());
    Get.lazyPut<HomeViewController>(() => HomeViewController());
    Get.lazyPut<SortingModalController>(() => SortingModalController());
    Get.lazyPut<CalendarViewController>(() => CalendarViewController());
  }
}
