import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/calendar/views/calendar_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final pages = [HomeView(), CalendarView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(children: [Row(
          // 헤더 부분
        ), pages[controller.currentIndex.value]]),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '캘린더',
            ),
          ],
        ),
      ),
      endDrawer: EndDrawer()
    );
  }
}
