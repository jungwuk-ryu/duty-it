import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/modules/job/controllers/job_sorting_modal_controller.dart';
import 'package:duty_it/app/widgets/app_sorting_bottom_modal_content.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class JobSortingBottomModal extends StatefulWidget {
  const JobSortingBottomModal({super.key});

  @override
  State<JobSortingBottomModal> createState() => _JobSortingBottomModalState();
}

class _JobSortingBottomModalState extends State<JobSortingBottomModal> {
  JobSortingModalController get controller =>
      Get.find<JobSortingModalController>();

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
    return AppSortingBottomModalContent<JobSortingType>(
      selectedType: controller.selectedType,
      types: JobSortingType.values,
      displayNameOf: (type) => type.displayName,
      onApply: controller.selectType,
    );
  }
}
