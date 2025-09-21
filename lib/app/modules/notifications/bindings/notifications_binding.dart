import 'package:get/get.dart';

import '../controllers/notifications_view_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsViewController>(
      () => NotificationsViewController(),
    );
  }
}
