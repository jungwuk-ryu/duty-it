import 'package:duty_it/app/modules/notifications/widgets/notification_item.dart';
import 'package:duty_it/app/widgets/custom_divider.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_view_controller.dart';

class NotificationsView extends GetView<NotificationsViewController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SimpleAppBar(title: '알림'),
          Expanded(
            child: RefreshIndicator.adaptive(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.notificationList.length,
                  itemBuilder: (_, i) =>
                      NotificationItem(controller.notificationList[i]),
                ),
              ),
              onRefresh: () async => await controller.loadNotificationList(),
            ),
          ),
        ],
      ),
    );
  }
}
