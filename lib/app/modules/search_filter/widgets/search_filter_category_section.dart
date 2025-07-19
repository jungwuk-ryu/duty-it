import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/controllers/search_filter_view_controller.dart';
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
          children: [
            Text(
              '카테고리',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.60,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '중복 선택 가능',
              style: TextStyle(
                color: AppColors.g05,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
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
