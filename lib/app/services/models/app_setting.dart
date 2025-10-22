import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get_storage/get_storage.dart';

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