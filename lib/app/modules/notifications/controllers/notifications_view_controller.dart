import 'package:duty_it/app/modules/notifications/models/fcm_notification.dart';
import 'package:duty_it/app/modules/notifications/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsViewController extends GetxController
    with WidgetsBindingObserver {
  NotificationRepository get repo => Get.find<NotificationRepository>();
  RxList notificationList = RxList();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initList();
  }

  Future<void> _initList() async {
    await repo.loadFromDisk();
    loadNotificationList();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      repo.loadFromDisk();
    }
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
