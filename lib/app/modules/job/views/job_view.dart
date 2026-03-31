import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:flutter/cupertino.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/job/widgets/job_card.dart';
import 'package:duty_it/app/modules/job/widgets/job_filter_empty_indicator.dart';
import 'package:duty_it/app/modules/job/widgets/job_header.dart';
import 'package:duty_it/app/modules/home/widgets/no_bookmarked_item_indicator.dart';
import 'package:duty_it/app/modules/home/widgets/no_search_item_indicator.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';

class JobView extends GetView<JobViewController> {
  const JobView({super.key});

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
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          floating: true,
          snap: true,
          automaticallyImplyLeading: false,
          actions: const <Widget>[SizedBox.shrink()],
          leading: const SizedBox.shrink(),
          flexibleSpace: FlexibleSpaceBar(
            background: JobHeader(controller: controller),
          ),
        ),
        AdaptiveHeightSliverPersistentHeader(
          pinned: true,
          child: JobHeader(controller: controller),
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
                duration: const Duration(milliseconds: 120),
                height: showIndicator
                    ? _refreshIndicatorAreaHeight
                    : _listTopSpacing,
                alignment: Alignment.topCenter,
                child: showIndicator
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: isRefreshing
                              ? const CircularProgressIndicator.adaptive()
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

          return PagedSliverList<String?, Rx<JobPosting>>(
            state: controller.pagingState,
            fetchNextPage: controller.fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate<Rx<JobPosting>>(
              animateTransitions: true,
              transitionDuration: const Duration(milliseconds: 100),
              itemBuilder: (_, item, __) => JobCard(jobRx: item),
              firstPageProgressIndicatorBuilder: (_) => isPullToRefreshing
                  ? const SizedBox.shrink()
                  : const Center(child: CircularProgressIndicator.adaptive()),
              newPageProgressIndicatorBuilder: (_) => isPullToRefreshing
                  ? const SizedBox.shrink()
                  : const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
              noItemsFoundIndicatorBuilder: (_) {
                if (controller.selectedTab == JobTab.bookmark) {
                  return const NoBookmarkedItemIndicator(
                    text: '북마크된 채용공고가 없습니다.\n채용 리스트에서 북마크를 추가해보세요.',
                  );
                }

                if (controller.searchQuery.value.isNotEmpty) {
                  return const NoSearchItemIndicator();
                }

                if (Get.find<JobFilterService>().hasFilterChanges()) {
                  return const JobFilterEmptyIndicator();
                }

                return const NoSearchItemIndicator();
              },
              firstPageErrorIndicatorBuilder: (_) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: AppNormalButton(
                    text: '재시도',
                    onTap: () async {
                      await controller.fetchNextPage(clearPage: true);
                    },
                  ),
                ),
              ),
              newPageErrorIndicatorBuilder: (_) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
