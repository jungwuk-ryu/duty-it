import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/services/models/app_setting.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsService extends GetxService {
  static const String storageBoxName = 'appSettings';

  late final GetStorage _box = GetStorage(storageBoxName);
  late final AppSetting<String> eventSortingTypeSetting;
  late final AppSetting<bool> dontShowAutoAddModal;

  @override
  void onInit() async {
    super.onInit();

    eventSortingTypeSetting = AppSetting(key: 'event_sorting_type', box: _box, defaultValue: EventSortingType.latest.name);
    dontShowAutoAddModal = AppSetting(key: 'dont_show_auto_add_modal', box: _box, defaultValue: false);
  }

  EventSortingType get eventSortingType => EventSortingType.fromName(eventSortingTypeSetting.value);
  set eventSortingType(EventSortingType t) => eventSortingTypeSetting.value = t.name;

}
