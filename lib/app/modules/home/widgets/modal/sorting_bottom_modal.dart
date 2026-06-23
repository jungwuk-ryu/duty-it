import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/widgets/app_sorting_bottom_modal_content.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

class SortingBottomModal extends StatefulWidget {
  const SortingBottomModal({super.key});

  @override
  State<SortingBottomModal> createState() => _SortingBottomModalState();
}

class _SortingBottomModalState extends State<SortingBottomModal> {
  SortingModalController get controller => Get.find<SortingModalController>();

  @override
  void initState() {
    Get.put<SortingModalController>(SortingModalController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SortingModalController>();
  }

  @override
  Widget build(BuildContext context) {
    return AppSortingBottomModalContent<EventSortingType>(
      selectedType: controller.selectedType,
      types: EventSortingType.values,
      displayNameOf: (type) => type.displayName,
      onApply: controller.selectType,
    );
  }
}
