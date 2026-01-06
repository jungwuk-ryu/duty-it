import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
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
      GetStorage.init(HomeViewCache.boxName),
      GetStorage.init(appInfoBoxName),
      Future.delayed(Duration(seconds: 1)),
    ]);
    PackageInfo packageInfo = results[0];
    GetStorage appInfoBox = GetStorage(appInfoBoxName);
    //String? oldVersion = appInfoBox.read('old_version');
    appInfoBox.write('old_version', packageInfo.version);

    Get.offAllNamed(Routes.MAIN);
  }
}
