import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/widgets/event_card.dart';
import 'package:duty_it/app/modules/home/widgets/events_first_page_error_indicator.dart';
import 'package:duty_it/app/modules/home/widgets/home_app_bar.dart';
import 'package:duty_it/app/modules/home/widgets/home_header.dart';
import 'package:duty_it/app/modules/home/widgets/no_bookmarked_item_indicator.dart';
import 'package:duty_it/app/modules/home/widgets/no_search_item_indicator.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
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
        key: controller.refreshIndicatorKey,
        onRefresh: () async {
          await controller.fetchNextPage(clearPage: true);
          controller.checkNewNotification();
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
              return PagedSliverList<String?, EventCard>(
                state: controller.pagingState,
                fetchNextPage: controller.fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<EventCard>(
                  animateTransitions: true,
                  transitionDuration: Duration(milliseconds: 100),
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
                  noItemsFoundIndicatorBuilder: (_) {
                    HomeTab tab = controller.selectedTab;
                    if (tab == HomeTab.bookmark) {
                      return NoBookmarkedItemIndicator();
                    }

                    return NoSearchItemIndicator();
                  },
                  firstPageErrorIndicatorBuilder: (_) => Center(
                    child: EventsFirstPageErrorIndicator(
                      controller: controller,
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (_) => Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: AppNormalButton(
                          text: '재시도',
                          onTap: () async {
                            await controller.fetchNextPage();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
