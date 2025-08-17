import 'package:get/get.dart';

import '../controllers/login_view_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewController>(() => LoginViewController());
  }
}
