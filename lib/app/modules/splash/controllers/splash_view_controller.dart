import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashViewController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    final String appInfoBoxName = "appInfo";

    var results = await Future.wait([
      PackageInfo.fromPlatform(),
      GetStorage.init(AppSettingsService.storageBoxName),
      GetStorage.init(AuthService.storageBoxName),
      GetStorage.init(SearchFilterService.storageBoxName),
      GetStorage.init(appInfoBoxName),
      Future.delayed(Duration(seconds: 1)),
    ]);
    PackageInfo packageInfo = results[0];
    GetStorage appInfoBox = GetStorage(appInfoBoxName);
    //String? oldVersion = appInfoBox.read('old_version');
    appInfoBox.write('old_version', packageInfo.version);

    try {
      var authService = Get.find<AuthService>();

      if (authService.isLoggined()) {
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
      }
      FirebaseCrashlytics.instance.recordError(e, s, fatal: false);

      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
