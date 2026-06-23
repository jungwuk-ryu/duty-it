import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/job/controllers/job_filter_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobRegionSelectionBottomModal extends GetView<JobFilterViewController> {
  const JobRegionSelectionBottomModal({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 84),
                    child: Text(
                      '지역',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: controller.selectAllRegions,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 76),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '지역 초기화',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.g04,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 1.60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => ListView(
                children: [
                  _JobRegionItem(
                    title: '전체',
                    isSelected: controller.isRegionSelected(null),
                    onTap: controller.selectAllRegions,
                    highlight: true,
                  ),
                  ...controller.workRegions.map(
                    (region) => _JobRegionItem(
                      title: region.displayName,
                      isSelected: controller.isRegionSelected(region),
                      onTap: () => controller.toggleRegionSelection(region),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobRegionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool highlight;

  const _JobRegionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.main : AppColors.black;
    final fontWeight = isSelected || highlight
        ? FontWeight.w700
        : FontWeight.w400;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: fontWeight,
                  height: 1.20,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check, color: AppColors.main, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
