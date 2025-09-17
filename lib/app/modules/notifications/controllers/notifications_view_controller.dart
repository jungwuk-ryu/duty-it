import 'package:duty_it/app/modules/notifications/models/fcm_notification.dart';
import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:get/get.dart';

class NotificationsViewController extends GetxController {
  NotificationRepository get repo => Get.find<NotificationRepository>();
  RxList notificationList = RxList();

  @override
  void onInit() {
    super.onInit();
    loadNotificationList();
  }

  Future<void> loadNotificationList({bool markAsRead = true}) async {
    List<FcmNotification> list = await repo.getNotificationList();

    if (markAsRead) {
      for (var noti in list) {
        if (!noti.read) await repo.readNotification(noti.id);
      }
    }

    notificationList.value = list;
  }

  Future<void> removeNotification(String id) async {
    notificationList.removeWhere((e) => e.id == id);
    await repo.removeNotification(id);
  }

}
