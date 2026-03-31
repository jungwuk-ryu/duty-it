import 'package:duty_it/app/modules/calendar/controllers/calendar_view_controller.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/services/event/app_event_service.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/in_app_review_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:get/get.dart';

import '../controllers/main_view_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppEventService>(AppEventService());
    Get.put<InAppReviewService>(InAppReviewService());
    Get.put<SearchFilterService>(SearchFilterService());
    Get.put<JobFilterService>(JobFilterService());
    Get.put<AppSettingsService>(AppSettingsService());
    Get.put<MainViewController>(MainViewController());
    Get.put<HomeViewController>(HomeViewController());
    Get.put<JobViewController>(JobViewController());
    Get.put<CalendarViewController>(CalendarViewController());
    Get.lazyPut(() => CalendarService());
  }
}
