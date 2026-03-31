import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/modules/job/controllers/job_sorting_modal_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobSortingBottomModal extends StatefulWidget {
  const JobSortingBottomModal({super.key});

  @override
  State<JobSortingBottomModal> createState() => _JobSortingBottomModalState();
}

class _JobSortingBottomModalState extends State<JobSortingBottomModal> {
  JobSortingModalController get controller => Get.find<JobSortingModalController>();

  @override
  void initState() {
    super.initState();
    Get.put<JobSortingModalController>(JobSortingModalController());
  }

  @override
  void dispose() {
    Get.delete<JobSortingModalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final types = JobSortingType.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBottomSheetHandle(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정렬',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List<Widget>.generate(types.length, (i) {
            final type = types[i];

            return Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) {
                controller.selectTypeAndClose(type);
                HapticFeedback.selectionClick();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Text(
                      type.displayName,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                    const Spacer(),
                    AppRadioButtom(
                      checked: controller.selectedType == type,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
