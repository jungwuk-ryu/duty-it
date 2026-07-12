import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/settings/controllers/notification_filter_controller.dart';
import 'package:duty_it/app/modules/settings/models/alarm_settings.dart';
import 'package:duty_it/app/modules/settings/models/notification_subscription.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

class NotificationSettingsController extends GetxController {
  final Lock _settingUpdateLock = Lock();
  final RxBool hasPermission = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<NotificationSubscription> subscriptions =
      <NotificationSubscription>[].obs;

  ApiClient get api => Get.find<ApiClient>();
  AuthService get authService => Get.find<AuthService>();

  AlarmSettings? get settings => authService.appUser?.alarmSettings;

  bool get pushNoti => hasPermission.value ? (settings?.push ?? false) : false;

  bool get eventBookmarkNoti => settings?.bookmark ?? false;

  bool get calendarNoti => settings?.calendar ?? false;

  bool get marketingNoti => settings?.marketing ?? false;

  bool get eventCustomNoti =>
      subscriptions.any((subscription) => subscription.type.isEvent);

  bool get jobCustomNoti =>
      subscriptions.any((subscription) => subscription.type.isJob);

  int get eventCustomCount =>
      subscriptions.where((subscription) => subscription.type.isEvent).length;

  int get jobCustomCount =>
      subscriptions.where((subscription) => subscription.type.isJob).length;

  @override
  void onInit() {
    super.onInit();
    refreshSettings();
  }

  Future<void> refreshSettings() async {
    isLoading.value = true;
    try {
      await _updatePermissionStatus();
      if (!authService.isLoggined()) {
        subscriptions.clear();
        return;
      }

      final user = await _ensureAppUserLoaded();
      if (user == null) return;

      await _fetchSubscriptions();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePushNoti() async {
    HapticFeedback.mediumImpact();

    if (!hasPermission.value) {
      final status = await Permission.notification.request();
      await _updatePermissionStatus();

      if (status.isPermanentlyDenied || status.isRestricted) {
        await openAppSettings();
      }

      if (settings?.push ?? true) return;
    }

    if (!hasPermission.value) return;

    await _updateAlarmSettings(
      (user) => user.alarmSettings.copyWith(push: !user.alarmSettings.push),
    );
  }

  Future<void> toggleEventBookmarkNoti() async {
    HapticFeedback.mediumImpact();

    await _updateAlarmSettings(
      (user) =>
          user.alarmSettings.copyWith(bookmark: !user.alarmSettings.bookmark),
    );
  }

  Future<void> toggleCalendarNoti() async {
    HapticFeedback.mediumImpact();

    await _updateAlarmSettings(
      (user) =>
          user.alarmSettings.copyWith(calendar: !user.alarmSettings.calendar),
    );
  }

  Future<void> toggleMarketingNoti() async {
    HapticFeedback.mediumImpact();

    await _updateAlarmSettings(
      (user) =>
          user.alarmSettings.copyWith(marketing: !user.alarmSettings.marketing),
    );
  }

  Future<void> toggleEventCustomNoti() async {
    if (eventCustomNoti) {
      await _deleteSubscriptions((subscription) => subscription.type.isEvent);
      return;
    }

    await openCustomFilter(NotificationFilterMode.event);
  }

  Future<void> toggleJobCustomNoti() async {
    if (jobCustomNoti) {
      await _deleteSubscriptions((subscription) => subscription.type.isJob);
      return;
    }

    await openCustomFilter(NotificationFilterMode.job);
  }

  Future<void> openCustomFilter(NotificationFilterMode mode) async {
    final result = await Get.toNamed(
      Routes.NOTIFICATION_FILTER,
      arguments: mode,
    );

    if (result == true) {
      await refreshSettings();
    }
  }

  Future<void> _deleteSubscriptions(
    bool Function(NotificationSubscription subscription) predicate,
  ) async {
    HapticFeedback.mediumImpact();

    final targets = subscriptions.where(predicate).toList();
    for (final subscription in targets) {
      final result = await api.deleteSubscription(subscription.id);
      if (result is RequestFail) {
        AppUtils.showSnackBar(
          result.serverFail?.message ?? '맞춤 알림 설정을 변경하지 못했어요.',
        );
        await _fetchSubscriptions();
        return;
      }
    }

    await _fetchSubscriptions();
  }

  Future<void> _fetchSubscriptions() async {
    final result = await api.getSubscriptions();
    if (result is RequestFail) {
      AppUtils.showSnackBar(
        result.serverFail?.message ?? '맞춤 알림 설정을 불러오지 못했어요.',
      );
      return;
    }

    subscriptions.assignAll(
      (result as RequestSuccess<List<NotificationSubscription>>).data,
    );
  }

  Future<void> _updateAlarmSettings(
    AlarmSettings Function(AppUser user) update,
  ) async {
    await _settingUpdateLock.synchronized(() async {
      final user = await _ensureAppUserLoaded();
      if (user == null) return;

      final result = await api.updateUserSettings(
        user.autoAddBookmarkToCalendar,
        update(user),
      );

      if (result is RequestFail) {
        AppUtils.showSnackBar(
          result.serverFail?.message ?? '알림 설정을 변경하지 못했어요.',
        );
      }
    });
  }

  Future<void> _updatePermissionStatus() async {
    final status = await Permission.notification.status;
    hasPermission.value = status.isGranted || status.isProvisional;
  }

  Future<AppUser?> _ensureAppUserLoaded() async {
    final user = await authService.ensureAppUserLoaded();
    if (user == null) {
      AppUtils.showSnackBar('사용자 정보를 불러오지 못했어요. 다시 시도해 주세요.');
    }
    return user;
  }
}
