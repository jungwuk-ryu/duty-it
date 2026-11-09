import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/widgets/sort_menu.dart';
import 'package:duty_it/app/widgets/adaptive_filter_row.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobHeader extends StatelessWidget {
  final JobViewController controller;

  const JobHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveSearchHeader(
            search: HomeSearchBar(
              controller: controller.searchTextEditingController,
              hintText: '원하는 채용공고를 찾아보세요!',
            ),
            filters: Obx(() {
              final filterService = Get.find<JobFilterService>();
              final filterApplied = filterService.hasFilterChanges();

              return AdaptiveFilterRow(
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
                    backgroundColor: filterApplied ? AppColors.main : null,
                    textColor: filterApplied ? AppColors.white : null,
                    onTap: () {
                      Get.toNamed(Routes.JOB_FILTER);
                    },
                  ),
                  SortMenu(
                    selected: controller.sortingType,
                    options: JobSortingType.values,
                    onSelected: (type) => controller.sortingType = type,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
