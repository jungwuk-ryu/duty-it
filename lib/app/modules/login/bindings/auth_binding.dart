import 'package:duty_it/app/modules/login/services/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.lazyPut<LoginViewController>(() => LoginViewController());
  }
}
