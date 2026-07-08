import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_subtitle.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobFilterRegionSection extends GetView<JobFilterViewController> {
  const JobFilterRegionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchFilterSectionTitle('지역별'),
            SizedBox(width: 8),
            SearchFilterSectionSubtitle('중복 선택 가능'),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: controller.showRegionSelectionBottomModal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Text(
                  '지역별',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.selectedRegionSummary,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: controller.hasSelectedRegions
                            ? AppColors.main
                            : AppColors.g05,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(Assets.icons.go.path, width: 12, height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
