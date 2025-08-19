import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashViewController extends GetxController {
  @override
  void onReady() async {
    super.onReady();

    await Future.delayed(Duration(seconds: 2));

    try {
      var authService = Get.find<AuthService>();

      if (authService.isLoggined()) {
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      // TODO : Crashlytics 로깅
      if (kDebugMode) {
        print(e);
      }

      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
