import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/end_drawer.dart';
import 'package:duty_it/gen/assets.gen.dart';

import '../controllers/main_view_controller.dart';

class MainView extends GetView<MainViewController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(child: Obx(() => controller.pages[controller.pageIndex.value])),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 50,
          currentIndex: controller.pageIndex.value,
          onTap: controller.changeTab,
          selectedFontSize: 10,
          selectedItemColor: AppColors.black,
          unselectedFontSize: 10,
          unselectedItemColor: AppColors.g04,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.paper.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 0
                    ? AppColors.black
                    : AppColors.g04,
              ),
              label: '행사',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.calendar.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 1
                    ? AppColors.black
                    : AppColors.g04,
              ),
              label: '캘린더',
            ),
          ],
        ),
      ),
      endDrawer: EndDrawer(),
    );
  }
}
