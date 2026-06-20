import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobAppBar extends StatelessWidget {
  JobViewController get controller => Get.find<JobViewController>();

  const JobAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = Get.find<AuthService>().isLoggined();
      final hasNewNotification = controller.hasNewNotification;

      return DuitTopAppBar(
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
