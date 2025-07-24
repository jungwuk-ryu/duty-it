import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_category_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_ended_event_section.dart';
import 'package:duty_it/app/modules/search_filter/widgets/search_filter_header.dart';
import 'package:duty_it/app/modules/search_filter/widgets/sections/search_filter_host_section.dart';
import 'package:duty_it/app/widgets/custom_divider.dart';
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
            SizedBox(height: 25.h),
            SearchFilterHeader(),
            SizedBox(height: 8.h),
            CustomDivider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, right: 16.w, left: 16.w),
                child: Column(
                  spacing: 24.h,
                  children: [SearchFilterCategorySection(),
                  SearchFilterHostSection(),
                  SearchFilterEndedEventSection()],
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onApplyButtonClicked,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '필터 적용',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
