import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_sorting_bottom_modal.dart';
import 'package:duty_it/app/modules/home/widgets/home_tab_button.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarkHeader extends GetView<BookmarkViewController> {
  const BookmarkHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Obx(
            () => HomeSearchBar(
              controller: controller.searchTextEditingController,
              hintText: controller.isJobTab
                  ? '원하는 채용공고를 찾아보세요!'
                  : '찾으시는 행사가 있나요?',
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => HomeTabButton(
                  isSelected: controller.isEventTab,
                  onTap: () =>
                      controller.selectedTab = BookmarkContentTab.event,
                  title: '행사',
                ),
              ),
              Obx(
                () => HomeTabButton(
                  isSelected: controller.isJobTab,
                  onTap: () => controller.selectedTab = BookmarkContentTab.job,
                  title: '채용',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final filterApplied = controller.isEventTab
                ? Get.find<SearchFilterService>().hasFilterChanges()
                : Get.find<JobFilterService>().hasFilterChanges();
            final sortingName = controller.isEventTab
                ? controller.eventSortingType.shortName
                : controller.jobSortingType.shortName;

            return Row(
              children: [
                CategoryTag(
                  name: '전체',
                  isSelected: !filterApplied,
                  onTap: controller.resetCurrentFilter,
                ),
                const SizedBox(width: 8),
                CategoryTag(
                  name: '필터',
                  isSelected: filterApplied,
                  imageAsset: Assets.icons.filter.path,
                  imageColor: filterApplied ? AppColors.white : null,
                  onTap: controller.openCurrentFilterPage,
                ),
                const Spacer(),
                CategoryTag(
                  name: sortingName,
                  isSelected: false,
                  imageAsset: Assets.icons.filterSort.path,
                  backgroundColor: AppColors.transparent,
                  textColor: AppColors.g05,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => const BookmarkSortingBottomModal(),
                    );
                  },
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
