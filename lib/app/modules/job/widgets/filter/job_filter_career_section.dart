import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_subtitle.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobFilterCareerSection extends GetView<JobFilterViewController> {
  const JobFilterCareerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchFilterSectionTitle('경력별'),
            SizedBox(width: 8),
            SearchFilterSectionSubtitle('중복 선택 가능'),
          ],
        ),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              IntrinsicWidth(
                child: CategoryTag(
                  name: '전체',
                  isSelected: controller.isCareerFilterSelected(null),
                  onTap: controller.clearSelectedCareerFilters,
                ),
              ),
              ...controller.careerFilters.map(
                (careerFilter) => IntrinsicWidth(
                  child: CategoryTag(
                    name: careerFilter.displayName,
                    isSelected: controller.isCareerFilterSelected(careerFilter),
                    onTap: () =>
                        controller.toggleCareerFilterSelection(careerFilter),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
