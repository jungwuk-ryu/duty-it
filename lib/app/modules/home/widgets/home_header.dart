import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeHeader extends StatelessWidget {
  final HomeViewController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          HomeSearchBar(controller: controller.searchTextEditingController),
          SizedBox(height: 18),

          Obx(() {
            var service = Get.find<SearchFilterService>();
            bool filterApplied = service.hasFilterChanges();

            return Row(
              children: [
                CategoryTag(
                  name: '전체',
                  isSelected: !filterApplied,
                  onTap: () {
                    Get.find<SearchFilterService>().resetFilter(false);
                  },
                ),
                SizedBox(width: 8),
                CategoryTag(
                  name: '필터',
                  isSelected: filterApplied,
                  imageAsset: Assets.icons.filter.path,
                  imageColor: filterApplied ? AppColors.white : null,
                  backgroundColor: filterApplied ? AppColors.main : null,
                  textColor: filterApplied ? AppColors.white : null,
                  onTap: () {
                    Get.toNamed(Routes.SEARCH_FILTER);
                  },
                ),
                Spacer(),
                Obx(
                  () => CategoryTag(
                    name: controller.sortingType.shortName,
                    isSelected: false,
                    imageAsset: Assets.icons.filterSort.path,
                    backgroundColor: AppColors.transparent,
                    textColor: AppColors.g05,
                    onTap: () {
                      controller.showSortingBottomModal();
                    },
                  ),
                ),
              ],
            );
          }),

          Obx(() {
            final service = Get.find<SearchFilterService>();
            final host = service.filter.host;
            if (host == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  avatar: const Icon(Icons.business_outlined, size: 18),
                  label: Text(host.name, overflow: TextOverflow.ellipsis),
                  deleteButtonTooltipMessage: '주최 필터 해제',
                  onDeleted: () =>
                      service.updateFilter(service.filter.copyWith(host: null)),
                ),
              ),
            );
          }),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}
