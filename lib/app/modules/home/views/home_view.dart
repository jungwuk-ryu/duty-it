import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/home_app_bar.dart';
import 'package:duty_it/app/modules/home/widgets/home_header.dart';
import 'package:duty_it/app/modules/home/widgets/no_bookmarked_item_indicator.dart';
import 'package:duty_it/app/modules/home/widgets/no_search_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';

class HomeView extends GetView<HomeViewController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          await controller.fetchNextPage(clearPage: true);
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              actions: <Widget>[Container()],
              leading: SizedBox.shrink(),
              flexibleSpace: FlexibleSpaceBar(background: HomeAppBar()),
            ),

            AdaptiveHeightSliverPersistentHeader(
              pinned: true,
              child: HomeHeader(controller: controller),
            ),

            Obx(() {
              return PagedSliverList<int, EventCard>(
                state: controller.pagingState,
                fetchNextPage: controller.fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<EventCard>(
                  itemBuilder: (context, item, index) => item,
                  firstPageProgressIndicatorBuilder: (_) =>
                          Center(child: CircularProgressIndicator.adaptive()),
                  newPageProgressIndicatorBuilder: (_) => Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  animateTransitions: true,
                  transitionDuration: Duration(milliseconds: 100),
                  noItemsFoundIndicatorBuilder: (_) {
                    HomeTab tab = controller.selectedTab;
                    if (tab == HomeTab.bookmark) {
                      return NoBookmarkedItemIndicator();
                    }

                    return NoSearchItemIndicator();
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
