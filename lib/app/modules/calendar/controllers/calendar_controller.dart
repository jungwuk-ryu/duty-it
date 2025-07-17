import 'package:get/get.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> _currentDateTime = DateTime.now().obs;
  get currentDateTime => _currentDateTime.value;
  set currentDateTime(value) => _currentDateTime.value = value;


  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
