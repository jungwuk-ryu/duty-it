import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/splash_view_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(ApiClient(), permanent: true);
    Get.put<SplashViewController>(SplashViewController());
  }
}
