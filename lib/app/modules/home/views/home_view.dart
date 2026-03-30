import 'package:flutter/cupertino.dart';
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

  static const double _listTopSpacing = 16;
  static const double _refreshIndicatorAreaHeight = 48;
  static const double _iosRefreshTriggerPullDistance = 64;
  static const double _iosRefreshIndicatorExtent = 44;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final useCupertinoRefreshControl =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    final scrollView = CustomScrollView(
      physics: useCupertinoRefreshControl
          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
          : const AlwaysScrollableScrollPhysics(),
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

        if (useCupertinoRefreshControl)
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: _iosRefreshTriggerPullDistance,
            refreshIndicatorExtent: _iosRefreshIndicatorExtent,
            onRefresh: controller.onPullToRefresh,
          )
        else
          Obx(() {
            final showIndicator = controller.shouldShowRefreshIndicator;
            final isRefreshing = controller.isPullToRefreshing;
            final progress = controller.pullToRefreshProgress;

            return SliverToBoxAdapter(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 120),
                height: showIndicator
                    ? _refreshIndicatorAreaHeight
                    : _listTopSpacing,
                alignment: Alignment.topCenter,
                child: showIndicator
                    ? Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: isRefreshing
                              ? CircularProgressIndicator.adaptive()
                              : CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 2.5,
                                ),
                        ),
                      )
                    : null,
              ),
            );
          }),

        if (useCupertinoRefreshControl)
          const SliverToBoxAdapter(child: SizedBox(height: _listTopSpacing)),

        Obx(() {
          final isPullToRefreshing = controller.isPullToRefreshing;

          return PagedSliverList<String?, EventCard>(
            state: controller.pagingState,
            fetchNextPage: controller.fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate<EventCard>(
              animateTransitions: true,
              transitionDuration: Duration(milliseconds: 100),
              itemBuilder: (context, item, index) => item,
              firstPageProgressIndicatorBuilder: (_) => isPullToRefreshing
                  ? const SizedBox.shrink()
                  : Center(child: CircularProgressIndicator.adaptive()),
              newPageProgressIndicatorBuilder: (_) => isPullToRefreshing
                  ? const SizedBox.shrink()
                  : Align(
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
                child: EventsFirstPageErrorIndicator(controller: controller),
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
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: useCupertinoRefreshControl
          ? scrollView
          : RefreshIndicator.noSpinner(
              onStatusChange: controller.updateRefreshIndicatorStatus,
              onRefresh: controller.onPullToRefresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: controller.onPullToRefreshScrollNotification,
                child: scrollView,
              ),
            ),
    );
  }
}
