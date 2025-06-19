import 'package:get/get.dart';
import 'package:myapp/app/modules/calendar/controllers/calendar_controller.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}
