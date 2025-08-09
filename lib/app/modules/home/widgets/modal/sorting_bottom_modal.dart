import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/sorting_modal_controller.dart';
import 'package:duty_it/app/modules/home/models/sorting_type.dart';
import 'package:duty_it/app/widgets/custom_radio_buttom.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SortingBottomModal extends StatelessWidget {
  const SortingBottomModal({super.key});

  SortingModalController get controller => Get.find<SortingModalController>();

  @override
  Widget build(BuildContext context) {
    List<SortingType> types = controller.getSortingTypes();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16.h),
        Text(
          "정렬",
          style: TextStyle(
            height: 1.60,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 8.h),
        ...List<Widget>.generate(types.length, (i) {
          SortingType type = types[i];

          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 16.w,
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
      ],
    );
  }
}
