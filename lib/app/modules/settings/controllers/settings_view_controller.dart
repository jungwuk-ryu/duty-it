import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/models/alarm_settings.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:get/get.dart';

class SettingsViewController extends GetxController {
  ApiClient get api => Get.find<ApiClient>();
  AuthService get authService => Get.find<AuthService>();
  AlarmSettings? get settings => authService.appUser?.alarmSettings;

  // 푸시 알림
  bool get pushNoti => settings?.push ?? false;

  // 마케팅 알림
  bool get marketingNoti => settings?.marketing ?? false;

  // 북마크 알림
  bool get bookmarkNoti => settings?.bookmark ?? false;

  // 캘린더 알림
  bool get calendarNoti => settings?.calendar ?? false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void togglePushNoti() {
    api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(push: !pushNoti),
    );
  }

  void toggleMarketingNoti() {
    api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(marketing: !marketingNoti),
    );
  }

  void toggleBookmarkNoti() {
    api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(bookmark: !bookmarkNoti),
    );
  }

  void toggleCalendarNoti() {
    api.updateUserSettings(
      authService.appUser?.autoAddBookmarkToCalendar ?? false,
      settings!.copyWith(calendar: !calendarNoti),
    );
  }
}
