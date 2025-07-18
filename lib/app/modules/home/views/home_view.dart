import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:myapp/app/modules/home/widgets/category_tag.dart';
import 'package:myapp/app/modules/home/widgets/event_card.dart';
import 'package:myapp/app/modules/home/widgets/home_header.dart';
import 'package:myapp/app/modules/home/widgets/home_tab_button.dart';
import 'package:myapp/app/modules/home/widgets/search_bar.dart';
import 'package:myapp/gen/assets.gen.dart';

import '../controllers/home_view_controller.dart';

class HomeView extends GetView<HomeViewController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          HomeHeader(),
          HomeSearchBar(controller: TextEditingController()),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                HomeTab tab = HomeTab.event;
                return HomeTabButton(
                  isSelected: controller.selectedTab == tab,
                  onTap: () => controller.selectedTab = tab,
                  title: "행사 리스트",
                );
              }),
              Obx(() {
                HomeTab tab = HomeTab.bookmark;
                return HomeTabButton(
                  isSelected: controller.selectedTab == tab,
                  onTap: () => controller.selectedTab = tab,
                  title: "북마크",
                );
              }),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              CategoryTag(name: "전체", isSelected: true),
              SizedBox(width: 8.w),
              CategoryTag(
                name: "필터",
                isSelected: false,
                imageAsset: Assets.icons.mageFilter.path,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Expanded(
            child: PagingListener<int, EventCard>(
              controller: controller.pagingController,
              builder: (context, state, fetchNextPage) =>
                  PagedListView<int, EventCard>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) => item,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
