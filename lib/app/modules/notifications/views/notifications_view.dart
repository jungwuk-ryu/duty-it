import 'package:duty_it/app/models/app_notification.dart';
import 'package:duty_it/app/modules/notifications/widgets/notification_item.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
                  return PagedListView<int, AppNotification>(
                    state: controller.pagingState,
                    fetchNextPage: controller.fetchNotificationList,
                    builderDelegate: PagedChildBuilderDelegate<AppNotification>(
                      itemBuilder: (_, item, _) => NotificationItem(item),
                      noItemsFoundIndicatorBuilder: (_) => Center(
                        child: Text(
                          "알림 목록이 비어 있습니다",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                onRefresh: () async => await controller.fetchNotificationList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
