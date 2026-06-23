import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobFilterRegionSection extends GetView<JobFilterViewController> {
  const JobFilterRegionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: controller.showRegionSelectionBottomModal,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: const [
                  Text(
                    '지역별',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.60,
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '중복 선택 가능',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.g05,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.hasSelectedRegions
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        controller.selectedRegionSummary,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.main,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.60,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 12),
            Image.asset(
              Assets.icons.go.path,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
