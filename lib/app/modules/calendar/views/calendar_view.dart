import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/widgets/calendar_view_title_section.dart';
import 'package:duty_it/app/modules/calendar/widgets/custom_calendar.dart';
import 'package:duty_it/app/modules/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/calendar_view_controller.dart';

class CalendarView extends GetView<CalendarViewController> {
  const CalendarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: DuitTopAppBar.height,
          child: ColoredBox(
            color: context.colors.canvas,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeAppBar(),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsetsGeometry.only(left: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => controller.showDateSelectionBottomModal(),
            child: Obx(
              () => CalendarViewTitleSection(dt: controller.currentDate),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(color: context.colors.border),
        ),
        SizedBox(height: 16),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (i) {
              controller.currentDate = controller.monthForPage(i);
            },
            itemBuilder: (_, i) {
              final month = controller.monthForPage(i);
              return CustomCalendar(key: ValueKey(month), date: month);
            },
          ),
        ),
      ],
    );
  }
}
