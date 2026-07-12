import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsService extends GetxService {
  static const String storageBoxName = 'appSettings';
  static const String _dontShowAutoAddModalKey = 'dont_show_auto_add_modal';

  late final GetStorage _box = GetStorage(storageBoxName);
  late final AppSetting<bool> includeDeviceEvents;
  late final AppSetting<String> eventSortingType;
  late final AppSetting<String> jobSortingType;

  @override
  void onInit() async {
    super.onInit();
    _box.remove(_dontShowAutoAddModalKey);
    includeDeviceEvents = AppSetting(
      key: 'include_device_events',
      box: _box,
      defaultValue: true,
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
  }
}
