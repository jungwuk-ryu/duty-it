import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/views/calendar_view.dart';
import 'package:duty_it/app/modules/home/views/home_view.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/end_drawer.dart';
import 'package:duty_it/gen/assets.gen.dart';

import '../controllers/main_view_controller.dart';

class MainView extends GetView<MainViewController> {
  MainView({super.key});

  final pages = [HomeView(), CalendarView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [Expanded(child: pages[controller.currentIndex.value])],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          elevation: 50,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedFontSize: 10,
          selectedItemColor: AppColors.black,
          unselectedFontSize: 10,
          unselectedItemColor: AppColors.g04,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.paper.path,
                width: 20.r,
                height: 20.r,
                color: controller.currentIndex.value == 0
                    ? AppColors.black
                    : AppColors.g04,
              ),
              label: '행사',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Assets.icons.calendar.path,
                width: 20.r,
                height: 20.r,
                color: controller.currentIndex.value == 1
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
