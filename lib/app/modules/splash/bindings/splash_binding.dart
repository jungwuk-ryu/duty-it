import 'package:get/get.dart';

import '../controllers/splash_view_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashViewController>(SplashViewController());
  }
}
