import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  HomeViewController get controller => Get.find<HomeViewController>();

  const HomeAppBar({super.key, this.actionsOnly = false});
  final bool actionsOnly;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = Get.find<AuthService>().isLoggined();
      final hasNewNotification = controller.hasNewNotification;

      return DuitTopAppBar(
        actionsOnly: actionsOnly,
        showNotifications: true,
        hasNewNotification: isLoggedIn && hasNewNotification,
        onNotificationsTap: () {
          if (!Get.find<AuthService>().isLoggined()) {
            Get.toNamed(Routes.LOGIN);
            return;
          }
          controller.openNotificationsPage();
        },
        onMenuTap: Get.find<MainViewController>().openEndDrawer,
      );
    });
  }
}
