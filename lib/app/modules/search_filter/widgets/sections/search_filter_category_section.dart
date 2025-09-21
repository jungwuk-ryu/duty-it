import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_subtitle.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_section.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

class SearchFilterCategorySection extends SearchFilterSection {
  const SearchFilterCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchFilterSectionTitle("카테고리"),
            SizedBox(width: 8),
            SearchFilterSectionSubtitle('중복 선택 가능'),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Obx(
              () => IntrinsicWidth(
                child: CategoryTag(
                  name: '전체',
                  isSelected: !controller.hasSelectedCategories(),
                  onTap: () => controller.clearSelectedCategories(),
                ),
              ),
            ),

            ...List.generate(
              controller.getCategories().length,
              (i) => Obx(() {
                String category = controller.getCategories()[i];
                return IntrinsicWidth(
                  child: CategoryTag(
                    name: category,
                    isSelected: controller.isCategorySelected(category),
                    onTap: () => controller.toggleCategorySelection(category),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
