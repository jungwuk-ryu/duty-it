import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/modules/settings/models/alarm_settings.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/calendar_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

class SettingsViewController extends GetxController {
  RxBool hasPermission = RxBool(false);
  final Lock _settingUpdateLock = Lock();
  ApiClient get api => Get.find<ApiClient>();
  AppSettingsService get appSettingsService => Get.find<AppSettingsService>();
  AuthService get authService => Get.find<AuthService>();

  // 북마크 알림
  bool get bookmarkNoti => settings?.bookmark ?? false;

  // 캘린더 행사 자동 추가
  bool get calendarAutoAdd =>
      authService.appUser?.autoAddBookmarkToCalendar ?? true;

  // 캘린더 알림
  bool get calendarNoti => settings?.calendar ?? false;

  // 캘린더 - 기기 행사 포함
  bool get includeDeviceEvents => appSettingsService.includeDeviceEvents.value;

  // 마케팅 알림
  bool get marketingNoti => settings?.marketing ?? false;

  // 푸시 알림
  bool get pushNoti => hasPermission.value ? (settings?.push ?? false) : false;

  AlarmSettings? get settings => authService.appUser?.alarmSettings;

  @override
  void onInit() async {
    super.onInit();
    _updatePermissionStatus();

    if (includeDeviceEvents) {
      var calService = Get.find<CalendarService>();
      var hasPermission = await calService.checkPermission();
      if (!hasPermission && includeDeviceEvents) toggleIncludeDeviceEvents();
    }
  }

  Future toggleAutoAdd() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(!(calendarAutoAdd), settings!);
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

  Future toggleMarketingNoti() async {
    HapticFeedback.mediumImpact();

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        authService.appUser?.autoAddBookmarkToCalendar ?? false,
        settings!.copyWith(marketing: !marketingNoti),
      );
    });
  }

  Future toggleIncludeDeviceEvents() async {
    HapticFeedback.mediumImpact();
    if (!includeDeviceEvents) {
      var calService = Get.find<CalendarService>();
      var hasPermission = await calService.requestPermission();
      if (!hasPermission) {
        openAppSettings();
        return;
      }
    }

    appSettingsService.includeDeviceEvents.value = !includeDeviceEvents;
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

  Future _updatePermissionStatus() async {
    final status = await Permission.notification.status;
    hasPermission.value = status.isGranted || status.isProvisional;
  }
}
