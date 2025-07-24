import 'package:duty_it/app/modules/search_filter/widgets/search_filter_section_title.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_section.dart';
import 'package:duty_it/app/widgets/category_tag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterEndedEventSection extends SearchFilterSection {
  const SearchFilterEndedEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchFilterSectionTitle("종료된 행사"),
        Obx(() {
          bool showEnded = controller.showEnded;

          return Row(
            spacing: 8.w,
            children: [
              CategoryTag(
                name: "안 보기",
                isSelected: !showEnded,
                onTap: () {
                  controller.showEnded = false;
                },
              ),
              CategoryTag(
                name: "보기",
                isSelected: showEnded,
                onTap: () {
                  controller.showEnded = true;
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
