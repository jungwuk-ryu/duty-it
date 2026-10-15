import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsService extends GetxService {
  static const String storageBoxName = 'appSettings';
  static const String _dontShowAutoAddModalKey = 'dont_show_auto_add_modal';
  static const String _analyticsCollectionKey = 'analytics_collection_enabled';

  late final GetStorage _box = GetStorage(storageBoxName);
  late final AppSetting<bool> includeDeviceEvents;
  late final AppSetting<bool> analyticsCollectionEnabled;
  late final AppSetting<String> eventSortingType;
  late final AppSetting<String> jobSortingType;

  @override
  void onInit() async {
    super.onInit();
    _box.remove(_dontShowAutoAddModalKey);
    // 기기 캘린더 일정은 사용자가 직접 켠 경우에만 읽는다.
    includeDeviceEvents = AppSetting(
      key: 'include_device_events',
      box: _box,
      defaultValue: false,
    );
    eventSortingType = AppSetting(
      key: 'event_sorting_type',
      box: _box,
      defaultValue: 'latest',
    );
    jobSortingType = AppSetting(
      key: 'job_sorting_type',
      box: _box,
      defaultValue: 'latest',
    );
    analyticsCollectionEnabled = AppSetting(
      key: _analyticsCollectionKey,
      box: _box,
      defaultValue: true,
    );
  }

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    final wasEnabled = analyticsCollectionEnabled.value;
    analyticsCollectionEnabled.value = enabled;
    // 다시 켤 때도 꺼져 있던 동안 쌓인 오류 보고는 보내지 않는다.
    await applyAnalyticsCollection(
      enabled,
      discardUnsentReports: !enabled || !wasEnabled,
    );
  }

  /// 저장된 이용 통계 수집 설정을 Firebase에 반영한다.
  /// 서비스가 등록되기 전인 앱 시작 시점에 호출된다.
  static Future<void> applyStoredAnalyticsCollection() async {
    try {
      await GetStorage.init(storageBoxName);
      final stored = GetStorage(storageBoxName).read(_analyticsCollectionKey);
      final enabled = stored is bool ? stored : true;
      await applyAnalyticsCollection(enabled, discardUnsentReports: !enabled);
    } catch (e) {
      debugPrint('이용 통계 수집 설정을 적용하지 못했습니다: $e');
    }
  }

  /// [discardUnsentReports]가 true이면 수집을 끈 동안 기기에 쌓인 오류 보고를
  /// 전송하지 않도록 먼저 지운다.
  static Future<void> applyAnalyticsCollection(
    bool enabled, {
    bool discardUnsentReports = false,
  }) async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);
    if (kIsWeb) return;

    final crashlytics = FirebaseCrashlytics.instance;
    if (discardUnsentReports) await crashlytics.deleteUnsentReports();
    await crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}
