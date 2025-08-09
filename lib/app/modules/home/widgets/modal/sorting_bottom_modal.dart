import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/app/widgets/custom_radio_buttom.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SortingBottomModal extends StatelessWidget {
  const SortingBottomModal({super.key});

  SortingModalController get controller => Get.find<SortingModalController>();

  @override
  Widget build(BuildContext context) {
    List<EventSortingType> types = EventSortingType.values;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24.h),
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
          SizedBox(height: 8.h),
          ...List<Widget>.generate(types.length, (i) {
            EventSortingType type = types[i];

            return Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 20.h,
              ),
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
                  Expanded(child: SizedBox()),
                  Obx(() {
                    var selectedType = controller.selectedType;
                    return CustomRadioButtom(
                      checked: selectedType == type,
                      onTap: () => controller.selectedType = type,
                    );
                  }),
                ],
              ),
            );
          }),
          AppNormalButton(text: '정렬 적용', onTap: () => controller.applyAndClose()),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
