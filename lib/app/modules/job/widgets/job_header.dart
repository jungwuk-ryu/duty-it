import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/widgets/home_tab_button.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/main/controllers/main_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:duty_it/app/widgets/duit_top_app_bar.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobHeader extends StatelessWidget {
  final JobViewController controller;

  const JobHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => DuitTopAppBar(
              showNotifications: Get.find<AuthService>().isLoggined(),
              hasNewNotification: controller.hasNewNotification,
              onNotificationsTap: controller.openNotificationsPage,
              onMenuTap: Get.find<MainViewController>().openEndDrawer,
            ),
          ),
          const SizedBox(height: 20),
          HomeSearchBar(
            controller: controller.searchTextEditingController,
            hintText: '원하는 채용공고를 찾아보세요!',
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => HomeTabButton(
                  isSelected: controller.selectedTab == JobTab.job,
                  onTap: () => controller.selectedTab = JobTab.job,
                  title: '채용',
                ),
              ),
              Obx(
                () => HomeTabButton(
                  isSelected: controller.selectedTab == JobTab.bookmark,
                  onTap: () => controller.selectedTab = JobTab.bookmark,
                  title: '북마크',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final filterService = Get.find<JobFilterService>();
            final filterApplied = filterService.hasFilterChanges();

            return Row(
              children: [
                CategoryTag(
                  name: '전체',
                  isSelected: !filterApplied,
                  onTap: filterService.resetFilter,
                ),
                const SizedBox(width: 8),
                CategoryTag(
                  name: '필터',
                  isSelected: filterApplied,
                  imageAsset: Assets.icons.filter.path,
                  imageColor: filterApplied ? AppColors.white : null,
                  onTap: () {
                    Get.toNamed(Routes.JOB_FILTER);
                  },
                ),
                const Spacer(),
                Obx(
                  () => CategoryTag(
                    name: controller.sortingType.shortName,
                    isSelected: false,
                    imageAsset: Assets.icons.filterSort.path,
                    backgroundColor: AppColors.transparent,
                    textColor: AppColors.g05,
                    onTap: controller.showSortingBottomModal,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
