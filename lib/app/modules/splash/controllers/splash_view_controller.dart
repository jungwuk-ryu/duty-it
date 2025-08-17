import 'package:duty_it/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashViewController extends GetxController {
  @override
  void onReady() async {
    super.onReady();

    await Future.delayed(Duration(seconds: 2));

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.AUTH);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    } catch (e) {
      // TODO : Crashlytics 로깅
      if (kDebugMode) {
        print(e);
      }
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
