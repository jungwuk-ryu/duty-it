import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_subtitle.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterCategorySection extends StatelessWidget {
  SearchFilterViewController get controller =>
      Get.find<SearchFilterViewController>();

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
            SizedBox(width: 8.w),
            SearchFilterSectionSubtitle('중복 선택 가능'),
          ],
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            controller.getCategories().length,
            (i) => Obx(() {
              String category = controller.getCategories()[i];
              return IntrinsicWidth(
                child: CategoryTag(
                  isSelected: controller.isCategorySelected(category),
                  name: category,
                  onTap: () {
                    controller.toggleCategorySelection(category);
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
