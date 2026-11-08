import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/widgets/sort_menu.dart';
import 'package:duty_it/app/widgets/adaptive_filter_row.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
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
      color: context.colors.canvas,
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
            children: [
              Expanded(
                child: Obx(
                  () => HomeTabButton(
                    isSelected: controller.isEventTab,
                    onTap: () =>
                        controller.selectedTab = BookmarkContentTab.event,
                    title: '행사',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => HomeTabButton(
                    isSelected: controller.isJobTab,
                    onTap: () =>
                        controller.selectedTab = BookmarkContentTab.job,
                    title: '채용',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final filterApplied = controller.isEventTab
                ? Get.find<SearchFilterService>().hasFilterChanges()
                : Get.find<JobFilterService>().hasFilterChanges();
            return AdaptiveFilterRow(
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

                  onTap: controller.openCurrentFilterPage,
                ),
                if (controller.isEventTab)
                  SortMenu(
                    selected: controller.eventSortingType,
                    options: EventSortingType.values,
                    onSelected: (type) => controller.eventSortingType = type,
                  )
                else
                  SortMenu(
                    selected: controller.jobSortingType,
                    options: JobSortingType.values,
                    onSelected: (type) => controller.jobSortingType = type,
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
