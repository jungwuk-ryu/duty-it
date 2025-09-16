import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationsViewController extends GetxController {
  
  RxList notificationList = RxList();

  @override
  void onInit() {
    super.onInit();
    loadNotificationList();
  }



  Future<void> loadNotificationList() async {
    var storage = await _storage;
    storage.
  }


}
