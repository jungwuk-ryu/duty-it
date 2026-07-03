import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashViewController extends GetxController {
  static const String appInfoBoxName = "appInfo";
  static final List<String> storageBoxNames = List.unmodifiable([
    AppSettingsService.storageBoxName,
    AuthService.storageBoxName,
    SearchFilterService.storageBoxName,
    JobFilterService.storageBoxName,
    HomeViewCache.boxName,
    appInfoBoxName,
    CalendarService.registeredEventsBoxName,
  ]);

  @override
  void onReady() async {
    super.onReady();

    var results = await Future.wait([
      PackageInfo.fromPlatform(),
      ...storageBoxNames.map(GetStorage.init),
      Future.delayed(Duration(seconds: 1)),
    ]);
    PackageInfo packageInfo = results[0];
    GetStorage appInfoBox = GetStorage(appInfoBoxName);
    //String? oldVersion = appInfoBox.read('old_version');
    appInfoBox.write('old_version', packageInfo.version);

    Get.offAllNamed(Routes.MAIN);
  }
}
