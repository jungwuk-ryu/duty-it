import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:get/get.dart';

import '../controllers/notifications_view_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationRepository>(NotificationRepository(), permanent: true);
    Get.lazyPut<NotificationsViewController>(
      () => NotificationsViewController(),
    );
  }
}
