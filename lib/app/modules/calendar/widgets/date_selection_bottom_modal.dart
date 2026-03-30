import 'dart:math';

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/calendar/controllers/date_selection_modal_controller.dart';
import 'package:duty_it/app/widgets/app_bottom_sheet_handle.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class DateSelectionBottomModal extends StatefulWidget {
  const DateSelectionBottomModal({super.key});

  @override
  State<DateSelectionBottomModal> createState() =>
      _DateSelectionBottomModalState();
}

class _DateSelectionBottomModalState extends State<DateSelectionBottomModal> {
  DateSelectionModalController get controller =>
      Get.find<DateSelectionModalController>();

  @override
  void initState() {
    Get.put(DateSelectionModalController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<DateSelectionModalController>();
  }

  @override
  Widget build(BuildContext context) {
    final double itemExtent = 50;
    final int startYear = 2000;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppBottomSheetHandle(),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "월 선택",
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
          SizedBox(height: 20),

          SizedBox(
            height: itemExtent * 3,
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: itemExtent * 3,
                        child: ScrollSnapList(
                          scrollDirection: Axis.vertical,
                          itemCount: 100,
                          initialIndex: max(
                            controller.baseDate.year - startYear,
                            0,
                          ).toDouble(),
                          itemSize: itemExtent,
                          onItemFocus: (i) {
                            controller.selectedYear = startYear + i;
                          },
                          itemBuilder: (context, i) {
                            final year = startYear + i;

                            return SizedBox(
                              height: itemExtent,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Obx(() {
                                  bool selected =
                                      controller.selectedYear == year;
                                  return AnimatedDefaultTextStyle(
                                    style: TextStyle(
                                      color: selected
                                          ? AppColors.black
                                          : AppColors.g05,
                                      fontSize: selected ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.60,
                                    ),
                                    duration: Duration(milliseconds: 100),
                                    child: Text(
                                      '$year년',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 64),
                    Expanded(
                      child: SizedBox(
                        height: itemExtent * 3,
                        child: ScrollSnapList(
                          scrollDirection: Axis.vertical,
                          itemCount: 12,
                          initialIndex: controller.baseDate.month - 1,
                          itemSize: itemExtent,
                          onItemFocus: (index) {
                            controller.selectedMonth = index + 1;
                          },
                          itemBuilder: (context, i) {
                            return SizedBox(
                              height: itemExtent,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Obx(() {
                                  bool selected =
                                      controller.selectedMonth == i + 1;
                                  return AnimatedDefaultTextStyle(
                                    style: TextStyle(
                                      color: selected
                                          ? AppColors.black
                                          : AppColors.g05,
                                      fontSize: selected ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.60,
                                    ),
                                    duration: Duration(milliseconds: 100),
                                    child: Text(
                                      '${i + 1}월',
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.g07.withAlpha(37),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      height: itemExtent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          AppNormalButton(text: '이동', onTap: controller.closeAndApply),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
