import 'package:get/get.dart';

import '../controllers/notification_filter_controller.dart';

class NotificationFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationFilterController>(
      () => NotificationFilterController(),
    );
  }
}
