import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/end_drawer.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_view_controller.dart';

class MainView extends GetView<MainViewController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.99,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: controller.pages[controller.pageIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.white,
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.pageIndex.value,
          onTap: controller.changeTab,
          selectedFontSize: 11,
          selectedItemColor: AppColors.main,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedFontSize: 11,
          unselectedItemColor: AppColors.g05,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.paper.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 0
                    ? AppColors.main
                    : AppColors.g05,
              ),
              label: '행사',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.job.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 1
                    ? AppColors.main
                    : AppColors.g05,
              ),
              label: '채용',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.bookmark.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 2
                    ? AppColors.main
                    : AppColors.g05,
              ),
              label: '북마크',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.calendar.path,
                width: 20,
                height: 20,
                color: controller.pageIndex.value == 3
                    ? AppColors.main
                    : AppColors.g05,
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
