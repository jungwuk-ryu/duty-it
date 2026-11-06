import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BookmarkAppBar extends GetView<BookmarkViewController> {
  const BookmarkAppBar({super.key, this.actionsOnly = false});
  final bool actionsOnly;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DuitTopAppBar(
        actionsOnly: actionsOnly,
        showNotifications: true,
        hasNewNotification: controller.hasNewNotification,
        onNotificationsTap: controller.openNotificationsPage,
        onMenuTap: Get.find<MainViewController>().openEndDrawer,
      ),
    );
  }
}
