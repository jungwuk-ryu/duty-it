import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:flutter/services.dart';
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
    List<EventSortingType> types = EventSortingType.values;

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
                "정렬",
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
            EventSortingType type = types[i];
            void select() {
              FocusManager.instance.primaryFocus?.unfocus();
              controller.selectTypeAndClose(type);
              HapticFeedback.selectionClick();
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: select,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                      tapSize: 24,
                      onTap: select,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
        ],
      ),
    );
  }
}
