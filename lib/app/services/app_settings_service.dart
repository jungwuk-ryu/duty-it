import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsService extends GetxService {
  static const String storageBoxName = 'appSettings';

  late final GetStorage _box = GetStorage(storageBoxName);
  late final AppSetting<bool> dontShowAutoAddModal;
  late final AppSetting<bool> includeDeviceEvents;

  @override
  void onInit() async {
    super.onInit();
    dontShowAutoAddModal = AppSetting(
      key: 'dont_show_auto_add_modal',
      box: _box,
      defaultValue: false,
    );
    includeDeviceEvents = AppSetting(
      key: 'include_device_events',
      box: _box,
      defaultValue: true,
    );
  }
}
