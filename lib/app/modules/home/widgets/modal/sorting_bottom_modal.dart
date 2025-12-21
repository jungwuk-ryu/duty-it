// ignore_for_file: unused_import

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/app_radio_buttom.dart';
import 'package:duty_it/gen/assets.gen.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "정렬",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.icons.close.path,
                    color: AppColors.g05,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...List<Widget>.generate(types.length, (i) {
            EventSortingType type = types[i];

            return Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) {
                controller.selectedType = type;
                HapticFeedback.selectionClick();
              },
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Text(
                      type.displayName,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                    Spacer(),
                    Obx(() {
                      var selectedType = controller.selectedType;
                      return AppRadioButtom(
                        checked: selectedType == type,
                        onTap: () {},
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
          AppNormalButton(
            text: '정렬 적용',
            onTap: () => controller.applyAndClose(),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
