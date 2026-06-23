import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/models/job_postings_response.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/job/widgets/job_sorting_bottom_modal.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_matcher.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum JobTab { job, bookmark }

class JobViewController extends GetxController {
  static const double _pullToRefreshTriggerFraction = 0.25;
  static const int _localFilterLookaheadLimit = 3;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchTextEditingController =
      TextEditingController();

  AppSettingsService get _settingsService => Get.find<AppSettingsService>();
  JobFilterService get _filterService => Get.find<JobFilterService>();

  final Rx<PagingState<String?, Rx<JobPosting>>> _pagingState =
      PagingState<String?, Rx<JobPosting>>(isLoading: true).obs;
  PagingState<String?, Rx<JobPosting>> get pagingState => _pagingState.value;
  set pagingState(PagingState<String?, Rx<JobPosting>> state) =>
      _pagingState.value = state;

  final Rx<JobTab> _selectedTab = JobTab.job.obs;
  JobTab get selectedTab => _selectedTab.value;
  set selectedTab(JobTab tab) {
    if (tab == JobTab.bookmark && !Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }
    _selectedTab.value = tab;
  }

  final Rx<JobSortingType> _sortingType = Rx(JobSortingType.latest);
  JobSortingType get sortingType => _sortingType.value;
  set sortingType(JobSortingType type) {
    _sortingType.value = type;
    _settingsService.jobSortingType.value = type.name;
  }

  final RxString searchQuery = ''.obs;
  final Lock _pageFetchLock = Lock();
  final RxBool _hasNewNotification = false.obs;
  bool get hasNewNotification => _hasNewNotification.value;
  final Rx<RefreshIndicatorStatus?> _refreshIndicatorStatus =
      Rx<RefreshIndicatorStatus?>(null);
  final RxBool _isPullToRefreshing = false.obs;
  final RxDouble _pullToRefreshProgress = 0.0.obs;
  double get pullToRefreshProgress => _pullToRefreshProgress.value;
  double _pullDragOffset = 0.0;

  bool get shouldShowRefreshIndicator {
    if (_isPullToRefreshing.value) return true;

    switch (_refreshIndicatorStatus.value) {
      case RefreshIndicatorStatus.drag:
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.snap:
        return true;
      case RefreshIndicatorStatus.refresh:
      case RefreshIndicatorStatus.done:
      case RefreshIndicatorStatus.canceled:
      case null:
        return false;
    }
  }

  bool get isPullToRefreshing => _isPullToRefreshing.value;

  @override
  void onInit() {
    super.onInit();
    _sortingType.value = JobSortingType.fromName(
      _settingsService.jobSortingType.value,
    );

    searchTextEditingController.addListener(
      () => searchQuery.value = searchTextEditingController.text.trim(),
    );

    debounce(searchQuery, (_) async {
      analytics.logSearch(searchTerm: searchQuery.value);
      await fetchNextPage(clearPage: true);
    }, time: const Duration(milliseconds: 500));

    ever(_selectedTab, (_) async {
      HapticFeedback.lightImpact();
      await fetchNextPage(clearPage: true);
    });

    ever(_filterService.filterRx, (_) => fetchNextPage(clearPage: true));
    ever(_sortingType, (_) => fetchNextPage(clearPage: true));

    checkNewNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNextPage(clearPage: true);
    });
  }

  @override
  void onClose() {
    searchTextEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void updateRefreshIndicatorStatus(RefreshIndicatorStatus? status) {
    _refreshIndicatorStatus.value = status;

    switch (status) {
      case RefreshIndicatorStatus.armed:
      case RefreshIndicatorStatus.snap:
      case RefreshIndicatorStatus.refresh:
        _pullToRefreshProgress.value = 1.0;
      case RefreshIndicatorStatus.done:
      case RefreshIndicatorStatus.canceled:
      case null:
        _resetPullToRefreshProgress();
      case RefreshIndicatorStatus.drag:
        break;
    }
  }

  Future<void> onPullToRefresh() async {
    _isPullToRefreshing.value = true;
    _pullToRefreshProgress.value = 1.0;
    try {
      await fetchNextPage(clearPage: true);
      await checkNewNotification();
    } finally {
      _isPullToRefreshing.value = false;
      _refreshIndicatorStatus.value = null;
      _resetPullToRefreshProgress();
    }
  }

  bool onPullToRefreshScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;

    final status = _refreshIndicatorStatus.value;
    final isTrackingPull =
        status == RefreshIndicatorStatus.drag ||
        status == RefreshIndicatorStatus.armed;

    if (notification is ScrollStartNotification &&
        notification.dragDetails != null &&
        notification.metrics.extentBefore == 0.0) {
      _pullDragOffset = 0.0;
      _pullToRefreshProgress.value = 0.0;
      return false;
    }

    if (!isTrackingPull) return false;

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axisDirection == AxisDirection.down) {
        _pullDragOffset -= notification.scrollDelta ?? 0.0;
      } else if (notification.metrics.axisDirection == AxisDirection.up) {
        _pullDragOffset += notification.scrollDelta ?? 0.0;
      }
      _updatePullToRefreshProgress(notification.metrics.viewportDimension);
    } else if (notification is OverscrollNotification) {
      if (notification.metrics.axisDirection == AxisDirection.down) {
        _pullDragOffset -= notification.overscroll;
      } else if (notification.metrics.axisDirection == AxisDirection.up) {
        _pullDragOffset += notification.overscroll;
      }
      _updatePullToRefreshProgress(notification.metrics.viewportDimension);
    }

    return false;
  }

  void _updatePullToRefreshProgress(double viewportDimension) {
    if (viewportDimension <= 0) return;

    final progress =
        (_pullDragOffset / (viewportDimension * _pullToRefreshTriggerFraction))
            .clamp(0.0, 1.0)
            .toDouble();

    _pullToRefreshProgress.value = progress;
  }

  void _resetPullToRefreshProgress() {
    _pullDragOffset = 0.0;
    _pullToRefreshProgress.value = 0.0;
  }

  Future<void> checkNewNotification() async {
    if (!Get.find<AuthService>().isLoggined()) {
      _hasNewNotification.value = false;
      return;
    }

    final api = Get.find<ApiClient>();
    final result = await api.getNotificationList(0, size: 1);
    if (result is RequestFail) return;

    final notiList = (result as RequestSuccess<List<AppNotification>>).data;
    if (notiList.isEmpty) {
      _hasNewNotification.value = false;
      return;
    }

    _hasNewNotification.value = !notiList.first.isRead;
  }

  void scrollUpJobList() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Future<void> fetchNextPage({bool clearPage = false}) async {
    if (!clearPage && pagingState.isLoading) return;
    await _pageFetchLock.synchronized(
      () async => _fetchNextPage(clearPage: clearPage),
    );
  }

  Future<void> _fetchNextPage({bool clearPage = false}) async {
    final previousPagingState = pagingState;
    final preserveVisibleItems = clearPage && _isPullToRefreshing.value;

    if (preserveVisibleItems) {
      pagingState = pagingState.copyWith(error: null, isLoading: false);
    } else {
      pagingState = pagingState.copyWith(
        isLoading: true,
        error: null,
        keys: clearPage ? null : const Omit(),
        pages: clearPage ? null : const Omit(),
      );
    }

    const size = 10;
    final filter = _filterService.filter;
    final currentKeys = clearPage
        ? <String?>[]
        : List<String?>.from(pagingState.keys ?? const <String?>[]);
    final currentPages = clearPage
        ? <List<Rx<JobPosting>>>[]
        : List<List<Rx<JobPosting>>>.from(
            pagingState.pages ?? const <List<Rx<JobPosting>>>[],
          );
    final pageKey = currentKeys.isEmpty ? null : currentKeys.last;

    bool hasError = false;

    try {
      final apiClient = Get.find<ApiClient>();
      var requestCursor = pageKey;
      var nextCursor = pageKey;
      var hasNext = false;
      final jobs = <JobPosting>[];
      final requiresLocalFiltering = _requiresLocalFiltering(filter);
      var fetchedPageCount = 0;

      do {
        final reqResult = await apiClient.getJobPostings(
          bookmarked: selectedTab == JobTab.bookmark,
          cursor: requestCursor,
          size: size,
          field: sortingType.field,
          searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
          workRegions: const [],
          employmentTypes: filter.employmentTypes.toList(),
        );

        if (reqResult is! RequestSuccess<JobPostingsResponse>) {
          throw _JobPostingRequestFailure(reqResult as RequestFail);
        }

        final response = reqResult.data;
        final pageInfo = response.pageInfo;
        jobs.addAll(
          response.jobs.where((job) => JobFilterMatcher.matches(job, filter)),
        );
        nextCursor = pageInfo.nextCursor;
        hasNext = pageInfo.hasNext;
        requestCursor = nextCursor;
        fetchedPageCount += 1;
      } while (jobs.isEmpty &&
          hasNext &&
          requiresLocalFiltering &&
          fetchedPageCount < _localFilterLookaheadLimit);

      if (!hasError) {
        pagingState = pagingState.copyWith(
          keys: [...currentKeys, nextCursor],
          pages: [
            ...currentPages,
            List<Rx<JobPosting>>.generate(jobs.length, (i) => Rx(jobs[i])),
          ],
          hasNextPage: hasNext,
        );
      }
    } catch (e, s) {
      hasError = true;
      if (kDebugMode && e is _JobPostingRequestFailure) {
        AppUtils.showSnackBar(
          '채용 목록을 불러오지 못했습니다: ${e.fail.serverFail?.message ?? ''}',
        );
      }
      if (kDebugMode) {
        print(e.toString() + s.toString());
      }
      FirebaseCrashlytics.instance.recordError(e, s);
    } finally {
      if (hasError) {
        if (preserveVisibleItems) {
          pagingState = previousPagingState.copyWith(
            error: previousPagingState.error,
          );
        } else {
          pagingState = pagingState.copyWith(
            keys: clearPage ? [] : const Omit(),
            pages: clearPage ? [] : const Omit(),
            error: true,
          );
        }
      }

      pagingState = pagingState.copyWith(isLoading: false);
    }
  }

  void showSortingBottomModal() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const JobSortingBottomModal(),
    );
  }

  Future<void> onBookmarkButtonClick(Rx<JobPosting> jobRx) async {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    final initialUser = await _ensureAppUserLoaded();
    if (initialUser == null) return;

    final job = jobRx.value;
    jobRx.value = job.copyWith(isBookmarked: !job.isBookmarked);

    final result = await Get.find<ApiClient>().toggleJobBookmark(job.id);
    if (result is RequestSuccess<bool>) {
      jobRx.value = job.copyWith(isBookmarked: result.data);
      if (selectedTab == JobTab.bookmark && !result.data) {
        await fetchNextPage(clearPage: true);
      }
      return;
    }

    jobRx.value = job;
    AppUtils.showSnackBar(
      (result as RequestFail).serverFail?.message ?? '북마크를 수정하지 못했습니다.',
    );
  }

  Future<AppUser?> _ensureAppUserLoaded() async {
    final user = await Get.find<AuthService>().ensureAppUserLoaded();
    if (user != null) return user;

    AppUtils.showSnackBar('사용자 정보를 불러오지 못했어요. 다시 시도해 주세요.');
    return null;
  }

  Future<void> openNotificationsPage() async {
    await Get.toNamed(Routes.NOTIFICATIONS);
    checkNewNotification();
  }

  void openJobDetail(Rx<JobPosting> jobRx) {
    Get.toNamed(Routes.JOB_DETAIL, arguments: {'jobRx': jobRx});
  }

  void openJobFilterPage() {
    Get.toNamed(Routes.JOB_FILTER);
  }

  bool _requiresLocalFiltering(JobFilter filter) {
    return JobFilterMatcher.requiresLocalFiltering(filter);
  }
}

class _JobPostingRequestFailure implements Exception {
  final RequestFail fail;

  const _JobPostingRequestFailure(this.fail);
}
