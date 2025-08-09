import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum EventSortingType {
  latest('최신 등록순', '최신순'),
  eventStartSoon('행사 날짜 임박순', '행사 날짜'),
  closingSoon('모집 마감 임박순', '모집 마감'),
  popular('인기순', '인기순');

  final String displayName;
  final String shortName; 

  const EventSortingType(this.displayName, this.shortName);

  static EventSortingType fromName(String name) {
    try {
    return EventSortingType.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return EventSortingType.values[0];
    }
  }
}

class AppSettingsService extends GetxService {
  final GetStorage _box = GetStorage('appSettings');
  late final _AppSetting<String> _eventSortingTypeName;

  @override
  void onInit() async {
    super.onInit();

    _eventSortingTypeName = _AppSetting(key: 'event_sorting_type', box: _box, defaultValue: EventSortingType.latest.name);
  }

  EventSortingType get eventSortingType => EventSortingType.fromName(_eventSortingTypeName.value);
  set eventSortingType(EventSortingType t) => _eventSortingTypeName.value = t.name;

}

class _AppSetting<T> {
  final String key;
  final GetStorage box;
  final T defaultValue;
  late final Rx<T> _value;

  _AppSetting({required this.key, required this.box, required this.defaultValue}) {
    _value = defaultValue.obs;

    var tempValue = box.read(key);
    if (tempValue != null) value = tempValue;

    debounce(_value, (v) {
      box.write(key, v);
    }, time: Duration(milliseconds: 100));
  }
  
  T get value => _value.value;
  set value(T v) => _value(v);

  
}