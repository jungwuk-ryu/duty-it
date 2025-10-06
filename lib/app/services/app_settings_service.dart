import 'package:duty_it/app/models/sort_direction.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum EventSortingType {
  //ID, NAME, START_DATE, RECRUITMENT_DEADLINE, VIEW_COUNT, CREATED_AT
  latest('최신 등록순', '최신순', 'ID', SortDirection.DESC),
  eventStartSoon('행사 날짜 임박순', '행사 날짜', 'START_DATE', SortDirection.ASC),
  closingSoon('모집 마감 임박순', '모집 마감', 'RECRUITMENT_DEADLINE', SortDirection.ASC),
  popular('인기순', '인기순', 'VIEW_COUNT', SortDirection.DESC);

  final String displayName;
  final String shortName; 
  final String field;
  final SortDirection sortDirection;

  const EventSortingType(this.displayName, this.shortName, this.field, this.sortDirection);

  static EventSortingType fromName(String name) {
    try {
    return EventSortingType.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return EventSortingType.values[0];
    }
  }
}

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