import 'package:get/get.dart';

class SettingsViewController extends GetxController {
  final RxBool _pushNoti = RxBool(true);
  bool get pushNoti => _pushNoti.value;
  set pushNoti(v) => _pushNoti(v);

  final RxBool _marketingNoti = RxBool(false);
  bool get marketingNoti => _marketingNoti.value;
  set marketingNoti(v) => _marketingNoti(v);

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

  void togglePushNoti() {
    pushNoti = !pushNoti;
    if (!pushNoti) marketingNoti = false;
  }

  void toggleMarketingNoti() {
    bool newValue = !marketingNoti;
    if (newValue && !pushNoti) return;
    marketingNoti = newValue;
  }
}
