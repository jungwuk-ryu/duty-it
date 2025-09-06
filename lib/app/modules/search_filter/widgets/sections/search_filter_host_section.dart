import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_section.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterHostSection extends SearchFilterSection {
  const SearchFilterHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchFilterSectionTitle("주최"),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 11.h,
            bottom: 11.h,
            left: 16.w,
            right: 8.w,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppColors.g04),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (controller.selectedHost == null) {
                controller.showHostSelectionBottomModal();
                return;
              }
              controller.clearSelectedHost();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(() {
                    String? host = controller.selectedHost?.name;
                    String text = host ?? '선택';
                    Color color = host == null ? AppColors.g05 : AppColors.main;

                    return Text(
                      text,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    );
                  }),
                ),

                Obx(() {
                  String? host = controller.selectedHost?.name;
                  String imgPath = host == null
                      ? Assets.icons.iconGoG05.path
                      : Assets.icons.iconTextdelete16.path;

                  return Image.asset(imgPath, width: 12.r, height: 12.r);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
