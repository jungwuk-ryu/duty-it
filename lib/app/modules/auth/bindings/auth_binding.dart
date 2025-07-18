import 'package:get/get.dart';

import '../controllers/auth_view_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthViewController>(() => AuthViewController());
  }
}
