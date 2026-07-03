import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  HomeViewController get controller => Get.find<HomeViewController>();

  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DuitTopAppBar(
        showNotifications: Get.find<AuthService>().isLoggined(),
        hasNewNotification: controller.hasNewNotification,
        onNotificationsTap: controller.openNotificationsPage,
        onMenuTap: Get.find<MainViewController>().openEndDrawer,
      ),
    );
  }
}
