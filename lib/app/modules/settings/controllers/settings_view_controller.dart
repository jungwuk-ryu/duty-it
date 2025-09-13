import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/models/alarm_settings.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsViewController extends GetxController {
  ApiClient get api => Get.find<ApiClient>();
  AuthService get authService => Get.find<AuthService>();
  AlarmSettings? get settings => authService.appUser?.alarmSettings;
  RxBool hasPermission = RxBool(false);

  // 푸시 알림
  bool get pushNoti => hasPermission.value ? (settings?.push ?? false) : false;

  // 마케팅 알림
  bool get marketingNoti => settings?.marketing ?? false;

  // 북마크 알림
  bool get bookmarkNoti => settings?.bookmark ?? false;

  // 캘린더 알림
  bool get calendarNoti => settings?.calendar ?? false;

  @override
  void onInit() async {
    super.onInit();
    _checkPermission();
  }

  Future _checkPermission() async {
    hasPermission.value = !(await Permission.notification.isDenied);
    if (!hasPermission.value) {
      await Permission.notification.request();
      hasPermission.value = !(await Permission.notification.isDenied);
    }
  }

  Future togglePushNoti() async{
    if (!hasPermission.value) {
      await Permission.notification.request();
      hasPermission.value = !(await Permission.notification.isDenied);
      
      if (settings?.push ?? true) return;
    }

    if (!hasPermission.value) return;

    await api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(push: !pushNoti),
    );
  }

  Future toggleMarketingNoti() async{
    await api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(marketing: !marketingNoti),
    );
  }

  Future toggleBookmarkNoti() async{
    await api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(bookmark: !bookmarkNoti),
    );
  }

  Future toggleCalendarNoti() async{
    await api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(calendar: !calendarNoti),
    );
  }
}
