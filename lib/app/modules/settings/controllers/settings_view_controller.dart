import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/settings/models/alarm_settings.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

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

  // 캘린더 행사 자동 추가
  bool get calendarAutoAdd =>
      authService.appUser?.autoAddBookmarkToCalendar ?? true;

  final Lock _settingUpdateLock = Lock();

  @override
  void onInit() async {
    super.onInit();
    _updatePermissionStatus();
  }

  Future _updatePermissionStatus() async {
    final status = await Permission.notification.status;
    hasPermission.value = status.isGranted || status.isProvisional;
  }

  Future togglePushNoti() async {
    HapticFeedback.mediumImpact();

    if (!hasPermission.value) {
      var status = await Permission.notification.request();
      await _updatePermissionStatus();

      if (status.isPermanentlyDenied || status.isRestricted) {
        await openAppSettings();
      }

      if (settings?.push ?? true) return;
    }

    if (!hasPermission.value) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        authService.appUser?.autoAddBookmarkToCalendar ?? false,
        settings!.copyWith(push: !pushNoti),
      );
    });
  }

  Future toggleMarketingNoti() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        authService.appUser?.autoAddBookmarkToCalendar ?? false,
        settings!.copyWith(marketing: !marketingNoti),
      );
    });
  }

  Future toggleBookmarkNoti() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        authService.appUser?.autoAddBookmarkToCalendar ?? false,
        settings!.copyWith(bookmark: !bookmarkNoti),
      );
    });
  }

  Future toggleCalendarNoti() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        authService.appUser?.autoAddBookmarkToCalendar ?? false,
        settings!.copyWith(calendar: !calendarNoti),
      );
    });
  }

  Future toggleAutoAdd() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(!(calendarAutoAdd), settings!);
    });
  }
}
