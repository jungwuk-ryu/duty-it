import 'package:duty_it/app/core/enums/event_sorting_type.dart';
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

    eventSortingTypeSetting = AppSetting(key: 'event_sorting_type', box: _box, defaultValue: EventSortingType.eventStartSoon.name);
    dontShowAutoAddModal = AppSetting(key: 'dont_show_auto_add_modal', box: _box, defaultValue: false);
  }

  EventSortingType get eventSortingType => EventSortingType.fromName(eventSortingTypeSetting.value);
  set eventSortingType(EventSortingType t) => eventSortingTypeSetting.value = t.name;

}

class AppSetting<T> {
  final String key;
  final GetStorage box;
  final T defaultValue;
  late final Rx<T> rxValue;

  AppSetting({required this.key, required this.box, required this.defaultValue}) {
    rxValue = defaultValue.obs;

    var tempValue = box.read(key);
    if (tempValue != null) value = tempValue;

    debounce(rxValue, (v) {
      box.write(key, v);
    }, time: Duration(milliseconds: 100));
  }
  
  T get value => rxValue.value;
  set value(T v) => rxValue(v);

  
}