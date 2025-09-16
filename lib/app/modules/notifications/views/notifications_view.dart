import 'package:duty_it/app/widgets/custom_divider.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SimpleAppBar(title: '알림'),
          CustomDivider(),
          Expanded(child: RefreshIndicator.adaptive(child: Obx(() => ListView.builder(itemBuilder: (_, i) => )), onRefresh: () async => await controller.loadNotificationList()));
        ],
      ),
    );
  }
}
