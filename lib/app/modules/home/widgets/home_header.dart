import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/widgets/sort_menu.dart';
import 'package:duty_it/app/widgets/adaptive_filter_row.dart';
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
      color: context.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveSearchHeader(
            search: HomeSearchBar(
              controller: controller.searchTextEditingController,
            ),
            filters: Obx(() {
              var service = Get.find<SearchFilterService>();
              bool filterApplied = service.hasFilterChanges();

              return AdaptiveFilterRow(
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
                  SortMenu(
                    selected: controller.sortingType,
                    options: EventSortingType.values,
                    onSelected: (type) => controller.sortingType = type,
                  ),
                ],
              );
            }),
          ),

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
        ],
      ),
    );
  }
}
