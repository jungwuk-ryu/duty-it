import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/search_filter_service.dart';
import 'package:get/get.dart';

import '../controllers/main_view_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchFilterService>(SearchFilterService());
    Get.lazyPut<AppSettingsService>(() => AppSettingsService());
    Get.lazyPut<MainViewController>(() => MainViewController());
    Get.lazyPut<HomeViewController>(() => HomeViewController());
    Get.lazyPut<CalendarViewController>(() => CalendarViewController());
  }
}
