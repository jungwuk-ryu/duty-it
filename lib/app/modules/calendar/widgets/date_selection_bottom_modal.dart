import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/controllers/date_selection_modal_controller.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DateSelectionBottomModal extends StatelessWidget {
  DateSelectionModalController get controller =>
      Get.find<DateSelectionModalController>();

  const DateSelectionBottomModal({super.key});

  @override
  Widget build(BuildContext context) {
    double itemExtent = 51.h;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16.h),
        Text(
          "월 선택",
          style: TextStyle(
            height: 1.60,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: itemExtent * 2,
          child: CupertinoPicker.builder(
            itemExtent: itemExtent,
            diameterRatio: 10,
            onSelectedItemChanged: (i) {
              controller.selectedItemIndex = i;
            },
            itemBuilder: (_, i) {
              DateTime ndt = controller.getDateTimeByIndex(i);

              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    Text(
                      '${ndt.year}년',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                    SizedBox(width: 64.w),
                    Text(
                      '${ndt.month}월',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.60,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30.h),
        AppNormalButton(text: '이동', onTap: controller.closeAndApply),
        SizedBox(height: 24.h),
      ],
    );
  }
}
