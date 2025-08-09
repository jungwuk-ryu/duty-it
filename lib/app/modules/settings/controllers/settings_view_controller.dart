import 'package:get/get.dart';

class SettingsViewController extends GetxController {
  /* START OF NOTIFICATION SETTINGS */

  // 푸시 알림
  final RxBool _pushNoti = RxBool(true);
  bool get pushNoti => _pushNoti.value;
  set pushNoti(v) => _pushNoti(v);

  // 마케팅 알림
  final RxBool _marketingNoti = RxBool(false);
  bool get marketingNoti => _marketingNoti.value;
  set marketingNoti(v) => _marketingNoti(v);

  // 행사 알림
  final RxBool _eventNoti = RxBool(true);
  bool get eventNoti => _eventNoti.value;
  set eventNoti(v) => _eventNoti(v);

  // 캘린더 알림
  final RxBool _calendarNoti = RxBool(true);
  bool get calendarNoti => _calendarNoti.value;
  set calendarNoti(v) => _calendarNoti(v);
  /* END OF NOTIFICATION SETTINGS */


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
    marketingNoti = !marketingNoti;
  }

  void toggleEventNoti() {
    eventNoti = !eventNoti;
  }

  void toggleCalendarNoti() {
    calendarNoti = !calendarNoti;
  }
}
