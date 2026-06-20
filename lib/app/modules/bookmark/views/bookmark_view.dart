import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_app_bar.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_event_card.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_header.dart';
import 'package:duty_it/app/modules/bookmark/widgets/bookmark_job_card.dart';
import 'package:duty_it/app/modules/home/widgets/no_bookmarked_item_indicator.dart';
import 'package:duty_it/app/modules/home/widgets/no_search_item_indicator.dart';
import 'package:duty_it/app/modules/job/widgets/job_filter_empty_indicator.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:duty_it/app/widgets/app_normal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';

class BookmarkView extends GetView<BookmarkViewController> {
  const BookmarkView({super.key});

  static const double _listTopSpacing = 16;

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller.scrollController,
      slivers: [
        const SliverAppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          floating: true,
          snap: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[SizedBox.shrink()],
          leading: SizedBox.shrink(),
          flexibleSpace: FlexibleSpaceBar(background: BookmarkAppBar()),
        ),
        const AdaptiveHeightSliverPersistentHeader(
          pinned: true,
          child: BookmarkHeader(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: _listTopSpacing)),
        Obx(() {
          if (controller.isEventTab) {
            return PagedSliverList<String?, Rx<Event>>(
              state: controller.eventPagingState,
              fetchNextPage: controller.fetchNextEventPage,
              builderDelegate: PagedChildBuilderDelegate<Rx<Event>>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 100),
                itemBuilder: (_, item, _) => BookmarkEventCard(eventRx: item),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                newPageProgressIndicatorBuilder: (_) =>
                    const _NewPageProgressIndicator(),
                noItemsFoundIndicatorBuilder: (_) =>
                    _NoBookmarkItems(tab: controller.selectedTab),
                firstPageErrorIndicatorBuilder: (_) => _RetryButton(
                  onTap: () => controller.fetchNextEventPage(clearPage: true),
                ),
                newPageErrorIndicatorBuilder: (_) =>
                    _RetryButton(onTap: controller.fetchNextEventPage),
              ),
            );
          }

          return PagedSliverList<String?, Rx<JobPosting>>(
            state: controller.jobPagingState,
            fetchNextPage: controller.fetchNextJobPage,
            builderDelegate: PagedChildBuilderDelegate<Rx<JobPosting>>(
              animateTransitions: true,
              transitionDuration: const Duration(milliseconds: 100),
              itemBuilder: (_, item, _) => BookmarkJobCard(jobRx: item),
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              newPageProgressIndicatorBuilder: (_) =>
                  const _NewPageProgressIndicator(),
              noItemsFoundIndicatorBuilder: (_) =>
                  _NoBookmarkItems(tab: controller.selectedTab),
              firstPageErrorIndicatorBuilder: (_) => _RetryButton(
                onTap: () => controller.fetchNextJobPage(clearPage: true),
              ),
              newPageErrorIndicatorBuilder: (_) =>
                  _RetryButton(onTap: controller.fetchNextJobPage),
            ),
          );
        }),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        onRefresh: controller.onPullToRefresh,
        child: scrollView,
      ),
    );
  }
}

class _NewPageProgressIndicator extends StatelessWidget {
  const _NewPageProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: AppNormalButton(text: '재시도', onTap: onTap),
      ),
    );
  }
}

class _NoBookmarkItems extends GetView<BookmarkViewController> {
  final BookmarkContentTab tab;

  const _NoBookmarkItems({required this.tab});

  @override
  Widget build(BuildContext context) {
    final hasSearchQuery = controller.searchQuery.value.isNotEmpty;
    if (hasSearchQuery) return const NoSearchItemIndicator();

    if (tab == BookmarkContentTab.event) {
      if (Get.find<SearchFilterService>().hasFilterChanges()) {
        return const NoSearchItemIndicator(text: '필터에 부합하는 행사가 없습니다.');
      }

      return const NoBookmarkedItemIndicator();
    }

    if (Get.find<JobFilterService>().hasFilterChanges()) {
      return const JobFilterEmptyIndicator();
    }

    return const NoBookmarkedItemIndicator(
      text: '북마크된 채용공고가 없습니다.\n채용 리스트에서 북마크를 추가해보세요.',
    );
  }
}
