import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:flutter/widgets.dart';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/drawer_account_button.dart';
import 'package:get/get.dart';

class DrawerAccoutSection extends StatelessWidget {
  MainViewController get controller => Get.find<MainViewController>();

  const DrawerAccoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          "계정",
          style: TextStyle(
            color: AppColors.g05,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.60,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                controller.getUserName(),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                ),
              ),
            ),
            DrawerAccountButton(),
          ],
        ),
      ],
    );
  }
}
