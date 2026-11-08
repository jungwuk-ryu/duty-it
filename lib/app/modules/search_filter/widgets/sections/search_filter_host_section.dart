import 'package:duty_it/app/widgets/app_asset_icon.dart';
import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_section.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';

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
          padding: EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 8),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: context.colors.disabled),
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
                    Color color = host == null
                        ? context.colors.muted
                        : context.colors.accent;

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
                  return host == null
                      ? AppAssetIcon(
                          asset: Assets.icons.go.path,
                          width: 12,
                          height: 12,
                        )
                      : Icon(
                          Icons.cancel_rounded,
                          color: context.colors.disabled,
                          size: 12,
                        );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
