import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobFilterClosedSection extends GetView<JobFilterViewController> {
  const JobFilterClosedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchFilterSectionTitle('종료된 공고'),
        Obx(() {
          final showClosed = controller.showClosed;

          return Row(
            children: [
              IntrinsicWidth(
                child: CategoryTag(
                  name: '보기',
                  isSelected: showClosed,
                  onTap: () => controller.showClosed = true,
                ),
              ),
              const SizedBox(width: 8),
              IntrinsicWidth(
                child: CategoryTag(
                  name: '안보기',
                  isSelected: !showClosed,
                  onTap: () => controller.showClosed = false,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
