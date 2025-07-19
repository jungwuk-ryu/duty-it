import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/widgets/category_tag.dart';
import 'package:duty_it/app/modules/home/widgets/home_tab_button.dart';
import 'package:duty_it/app/modules/home/widgets/search_bar.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeHeader extends StatelessWidget {
  final HomeViewController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          HomeSearchBar(controller: TextEditingController()),
          SizedBox(height: 18.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                const HomeTab tab = HomeTab.event;
                return HomeTabButton(
                  isSelected: controller.selectedTab == tab,
                  onTap: () => controller.selectedTab = tab,
                  title: '행사 리스트',
                );
              }),
              Obx(() {
                const HomeTab tab = HomeTab.bookmark;
                return HomeTabButton(
                  isSelected: controller.selectedTab == tab,
                  onTap: () => controller.selectedTab = tab,
                  title: '북마크',
                );
              }),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              const CategoryTag(name: '전체', isSelected: true),
              SizedBox(width: 8.w),
              CategoryTag(
                name: '필터',
                isSelected: false,
                imageAsset: Assets.icons.mageFilter.path,
                onTap: () {
                  Get.toNamed(Routes.SEARCH_FILTER);
                },
              ),
            ],
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
