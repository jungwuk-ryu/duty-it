import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
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
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future toggleAutoAdd() async {
    HapticFeedback.mediumImpact();
    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        !user.autoAddBookmarkToCalendar,
        user.alarmSettings,
      );
    });
  }

  Future toggleBookmarkNoti() async {
    HapticFeedback.mediumImpact();
    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        user.autoAddBookmarkToCalendar,
        user.alarmSettings.copyWith(bookmark: !user.alarmSettings.bookmark),
      );
    });
  }

  Future toggleCalendarNoti() async {
    HapticFeedback.mediumImpact();
    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        user.autoAddBookmarkToCalendar,
        user.alarmSettings.copyWith(calendar: !user.alarmSettings.calendar),
      );
    });
  }

  Future toggleMarketingNoti() async {
    HapticFeedback.mediumImpact();
    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        user.autoAddBookmarkToCalendar,
        user.alarmSettings.copyWith(marketing: !user.alarmSettings.marketing),
      );
    });
  }

  Future<void> openNotificationSettings() async {
    HapticFeedback.mediumImpact();
    await openAppSettings();
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
    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    await _settingUpdateLock.synchronized(() async {
      await api.updateUserSettings(
        user.autoAddBookmarkToCalendar,
        user.alarmSettings.copyWith(push: !user.alarmSettings.push),
      );
    });
  }

  Future<void> _initialize() async {
    await _updatePermissionStatus();
    if (authService.isLoggined()) {
      await _ensureAppUserLoaded();
    }

    if (!includeDeviceEvents) return;

    var calService = Get.find<CalendarService>();
    var hasPermission = await calService.checkPermission();
    if (!hasPermission && includeDeviceEvents) toggleIncludeDeviceEvents();
  }

  Future _updatePermissionStatus() async {
    final status = await Permission.notification.status;
    hasPermission.value = status.isGranted || status.isProvisional;
  }

  Future<AppUser?> _ensureAppUserLoaded() async {
    return authService.ensureAppUserLoaded();
  }
}
