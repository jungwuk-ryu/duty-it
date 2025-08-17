import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
  }

}