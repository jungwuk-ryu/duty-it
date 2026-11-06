import 'dart:math' as math;
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/end_drawer.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:duty_it/app/widgets/duit_glass.dart';
import 'package:duty_it/app/modules/home/widgets/home_app_bar.dart';
import 'package:duty_it/app/modules/job/widgets/job_app_bar.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_app_bar.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_view_controller.dart';

class MainView extends GetView<MainViewController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = DuoLayoutData.of(context);
    final edge = layout.verticalBarEdge;
    final hasSideBar = edge != null;
    final media = MediaQuery.of(context);
    final sideWidth = hasSideBar
        ? math.max(
            72.0,
            edge == 'left' ? media.viewPadding.left : media.viewPadding.right,
          )
        : 0.0;
    final railBounds = Rect.fromLTWH(
      edge == 'left' ? 0 : media.size.width - sideWidth,
      0,
      sideWidth,
      media.size.height,
    );
    final controlsTop = layout.obstructions
        .where((r) => r.overlaps(railBounds))
        .fold(media.padding.top, (double top, r) => math.max(top, r.bottom));
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: AppColors.canvas,
      extendBody: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bounds = Rect.fromLTRB(
            edge == 'left' ? sideWidth : media.padding.left,
            media.padding.top,
            constraints.maxWidth -
                (edge == 'right' ? sideWidth : media.padding.right),
            constraints.maxHeight - media.padding.bottom,
          );
          return SafeArea(
            left: edge != 'left',
            right: edge != 'right',
            bottom: hasSideBar,
            child: Row(
              children: [
                if (edge == 'left')
                  _sideNavigation(
                    sideWidth,
                    math.max(0, controlsTop - media.padding.top),
                  ),
                Expanded(
                  key: const ValueKey('main-content'),
                  child: DuoLayoutScope(
                    data: layout.withContentBounds(bounds),
                    child: DuoPostureTransition(
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
                          child: Padding(
                            key: ValueKey(controller.pageIndex.value),
                            padding: EdgeInsets.only(
                              bottom:
                                  !hasSideBar && controller.pageIndex.value == 3
                                  ? MediaQuery.paddingOf(context).bottom
                                  : 0,
                            ),
                            child: controller.pages[controller.pageIndex.value],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (edge == 'right')
                  _sideNavigation(
                    sideWidth,
                    math.max(0, controlsTop - media.padding.top),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: hasSideBar
          ? null
          : Obx(
              () => SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                  child: DuitGlass(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        currentIndex: controller.pageIndex.value,
                        onTap: controller.changeTab,
                        selectedFontSize: 11,
                        selectedItemColor: AppColors.main,
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
                  ),
                ),
              ),
            ),
      endDrawer: EndDrawer(),
    );
  }

  Widget _sideNavigation(double width, double top) {
    final icons = [
      Assets.icons.paper.path,
      Assets.icons.job.path,
      Assets.icons.bookmark.path,
      Assets.icons.calendar.path,
    ];
    const labels = ['행사', '채용', '북마크', '캘린더'];
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, top + 8, 8, 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Scroll if the keyboard or Split View leaves too little vertical room.
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Obx(
                        () => switch (controller.pageIndex.value) {
                          0 => const HomeAppBar(actionsOnly: true),
                          1 => const JobAppBar(actionsOnly: true),
                          2 => const BookmarkAppBar(actionsOnly: true),
                          _ => const HomeAppBar(actionsOnly: true),
                        },
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      DuitGlass(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < labels.length; i++)
                              Obx(() {
                                final selected =
                                    controller.pageIndex.value == i;
                                return Semantics(
                                  selected: selected,
                                  child: InkWell(
                                    onTap: () => controller.changeTab(i),
                                    child: Container(
                                      width: width - 16,
                                      constraints: const BoxConstraints(
                                        minHeight: 64,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            icons[i],
                                            width: 20,
                                            height: 20,
                                            color: selected
                                                ? AppColors.main
                                                : AppColors.g05,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            labels[i],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: selected
                                                  ? AppColors.main
                                                  : AppColors.g05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
