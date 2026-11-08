import 'dart:math' as math;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/main/widgets/drawer/end_drawer.dart';
import 'package:duty_it/app/modules/main/widgets/main_tab_bar.dart';
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
    final sideWidth = layout.sideBarWidth(media);
    final controlsTop = layout.sideControlsTop(media);
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: context.colors.canvas,
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
            // Feeds apply their bottom inset after the last item, so the
            // viewport can scroll to the edge behind the system gesture area.
            bottom: false,
            child: Row(
              children: [
                if (edge == 'left')
                  _sideNavigation(
                    sideWidth,
                    math.max(0, controlsTop - media.padding.top),
                    media.padding.bottom,
                  ),
                Expanded(
                  key: const ValueKey('main-content'),
                  child: DuoLayoutScope(
                    data: layout.withContentBounds(bounds),
                    child: DuoPostureTransition(
                      child: Obx(
                        () => AnimatedSwitcher(
                          duration:
                              media.disableAnimations ||
                                  media.accessibleNavigation
                              ? Duration.zero
                              : const Duration(milliseconds: 150),
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
                              bottom: controller.pageIndex.value == 3
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
                    media.padding.bottom,
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
                  child: MainTabBar(
                    selectedIndex: controller.pageIndex.value,
                    onSelected: controller.changeTab,
                  ),
                ),
              ),
            ),
      endDrawer: EndDrawer(),
    );
  }

  Widget _sideNavigation(double width, double top, double bottom) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, top + 8, 8, 8 + bottom),
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
                      Obx(
                        () => MainTabBar(
                          axis: Axis.vertical,
                          selectedIndex: controller.pageIndex.value,
                          onSelected: controller.changeTab,
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
