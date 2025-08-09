import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_app_bar.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_category_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_ended_event_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_host_section.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/search_filter_view_controller.dart';

class SearchFilterView extends GetView<SearchFilterViewController> {
  const SearchFilterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchFilterAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  spacing: 24.h,
                  children: [
                    SearchFilterCategorySection(),
                    SearchFilterHostSection(),
                    SearchFilterEndedEventSection(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              child: AppNormalButton(
                text: '필터 적용',
                onTap: controller.onApplyButtonClicked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
