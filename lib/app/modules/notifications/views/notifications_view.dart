import 'package:duty_it/app/modules/notifications/widgets/notification_item.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_view_controller.dart';

class NotificationsView extends GetView<NotificationsViewController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleAppBar(title: '알림', bottomMargin: 0),
            Expanded(
              child: RefreshIndicator.adaptive(
                child: Obx(() {
                  var list = controller.notificationList;
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        "알림 목록이 비어 있습니다",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => NotificationItem(list[i]),
                  );
                }),
                onRefresh: () async => await controller.loadNotificationList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
