import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/modules/notifications/widgets/notification_item.dart';
import 'package:duty_it/app/widgets/simple_app_bar.dart';
import 'package:duty_it/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notifications_view_controller.dart';

class NotificationsView extends GetView<NotificationsViewController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleAppBar(
              title: '알림',
              bottomMargin: 0,
              endChildren: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.openNotificationSettings,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.settings_outlined,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                child: Obx(() {
                  final items = controller.filteredNotifications;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (controller.hasNextPage &&
                          items.isNotEmpty &&
                          notification.metrics.extentAfter < 240) {
                        controller.fetchNotificationList();
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 18)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: _NotificationTabs(controller: controller),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        if (controller.conditionMessage != null) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              child: _ConditionBanner(controller: controller),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        ],
                        if (controller.isInitialLoading)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: _InitialLoadingIndicator(),
                          )
                        else if (controller.hasFirstPageError)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _ErrorIndicator(
                              onRetry: controller.retryNotificationList,
                            ),
                          )
                        else if (items.isEmpty &&
                            controller.isResolvingFilteredTab.value)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: _ResolvingFilteredTabIndicator(),
                          )
                        else if (items.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: _EmptyNotificationIndicator(),
                          )
                        else
                          SliverList.builder(
                            itemCount: items.length,
                            itemBuilder: (_, index) =>
                                NotificationItem(items[index]),
                          ),
                        if (controller.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: _NextPageLoadingIndicator(),
                          ),
                        if (controller.hasNextPageError)
                          SliverToBoxAdapter(
                            child: _NextPageErrorIndicator(
                              onRetry: controller.retryNotificationList,
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 32)),
                      ],
                    ),
                  );
                }),
                onRefresh: () async =>
                    await controller.refreshNotificationList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTabs extends StatelessWidget {
  final NotificationsViewController controller;

  const _NotificationTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NotificationTabChip(
          label: '전체',
          selected: controller.selectedTab.value == NotificationTab.all,
          onTap: () => controller.selectTab(NotificationTab.all),
        ),
        const SizedBox(width: 8),
        _NotificationTabChip(
          label: '행사',
          selected: controller.selectedTab.value == NotificationTab.event,
          onTap: () => controller.selectTab(NotificationTab.event),
        ),
        const SizedBox(width: 8),
        _NotificationTabChip(
          label: '채용',
          selected: controller.selectedTab.value == NotificationTab.job,
          onTap: () => controller.selectTab(NotificationTab.job),
        ),
      ],
    );
  }
}

class _NotificationTabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NotificationTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? AppColors.sub : AppColors.g02,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.main : AppColors.g06,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.20,
          ),
        ),
      ),
    );
  }
}

class _ConditionBanner extends StatelessWidget {
  final NotificationsViewController controller;

  const _ConditionBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final message = controller.conditionMessage;
    if (message == null) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.openSelectedConditionSettings,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.g01,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(Assets.icons.bell.path, width: 18, height: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.g06,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(Assets.icons.filter.path, width: 18, height: 18),
          ],
        ),
      ),
    );
  }
}

class _InitialLoadingIndicator extends StatelessWidget {
  const _InitialLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class _ResolvingFilteredTabIndicator extends StatelessWidget {
  const _ResolvingFilteredTabIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class _NextPageLoadingIndicator extends StatelessWidget {
  const _NextPageLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class _EmptyNotificationIndicator extends StatelessWidget {
  const _EmptyNotificationIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '알림 목록이 비어 있습니다',
        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.g06),
      ),
    );
  }
}

class _ErrorIndicator extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ErrorIndicator({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _RetryButton(message: '알림을 불러오지 못했어요', onRetry: onRetry),
    );
  }
}

class _NextPageErrorIndicator extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _NextPageErrorIndicator({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: _RetryButton(message: '더 불러오지 못했어요', onRetry: onRetry),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _RetryButton({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRetry,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: AppColors.g06,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.60,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '다시 시도',
              style: TextStyle(
                color: AppColors.main,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
