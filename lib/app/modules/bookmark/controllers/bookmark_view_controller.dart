import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_sorting_type.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/enums/job_sorting_type.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/models/job_postings_response.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/modules/notifications/models/app_notification.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:duty_it/app/services/app_settings_service.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_matcher.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:synchronized/synchronized.dart';

enum BookmarkContentTab { event, job }

class BookmarkViewController extends GetxController {
  static const int _eventPageSize = 5;
  static const int _jobPageSize = 10;
  static const int _localFilterJobPageSize = 100;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchTextEditingController =
      TextEditingController();
  final RxString searchQuery = ''.obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  AppSettingsService get _settingsService => Get.find<AppSettingsService>();
  SearchFilterService get _eventFilterService =>
      Get.find<SearchFilterService>();
  JobFilterService get _jobFilterService => Get.find<JobFilterService>();

  final Rx<BookmarkContentTab> _selectedTab = BookmarkContentTab.job.obs;
  BookmarkContentTab get selectedTab => _selectedTab.value;
  set selectedTab(BookmarkContentTab tab) {
    if (_selectedTab.value == tab) return;
    _selectedTab.value = tab;
  }

  final Rx<EventSortingType> _eventSortingType = EventSortingType.latest.obs;
  EventSortingType get eventSortingType => _eventSortingType.value;
  set eventSortingType(EventSortingType type) {
    _eventSortingType.value = type;
    _settingsService.eventSortingType.value = type.name;
  }

  final Rx<JobSortingType> _jobSortingType = JobSortingType.latest.obs;
  JobSortingType get jobSortingType => _jobSortingType.value;
  set jobSortingType(JobSortingType type) {
    _jobSortingType.value = type;
    _settingsService.jobSortingType.value = type.name;
  }

  final Rx<PagingState<String?, Rx<Event>>> _eventPagingState =
      PagingState<String?, Rx<Event>>(isLoading: true).obs;
  PagingState<String?, Rx<Event>> get eventPagingState =>
      _eventPagingState.value;
  set eventPagingState(PagingState<String?, Rx<Event>> state) =>
      _eventPagingState.value = state;

  final Rx<PagingState<String?, Rx<JobPosting>>> _jobPagingState =
      PagingState<String?, Rx<JobPosting>>(isLoading: true).obs;
  PagingState<String?, Rx<JobPosting>> get jobPagingState =>
      _jobPagingState.value;
  set jobPagingState(PagingState<String?, Rx<JobPosting>> state) =>
      _jobPagingState.value = state;

  final Lock _eventPageFetchLock = Lock();
  final Lock _jobPageFetchLock = Lock();
  final RxBool _hasNewNotification = false.obs;
  bool get hasNewNotification => _hasNewNotification.value;
  bool _eventOnlyFinishedMode = false;

  bool get isEventTab => selectedTab == BookmarkContentTab.event;
  bool get isJobTab => selectedTab == BookmarkContentTab.job;

  @override
  void onInit() {
    super.onInit();

    _eventSortingType.value = EventSortingType.fromName(
      _settingsService.eventSortingType.value,
    );
    _jobSortingType.value = JobSortingType.fromName(
      _settingsService.jobSortingType.value,
    );

    searchTextEditingController.addListener(
      () => searchQuery.value = searchTextEditingController.text.trim(),
    );

    debounce(searchQuery, (_) async {
      analytics.logSearch(searchTerm: searchQuery.value);
      await refreshCurrent();
    }, time: const Duration(milliseconds: 500));

    ever(_selectedTab, (_) async {
      HapticFeedback.lightImpact();
      await refreshCurrent();
    });

    ever(_eventFilterService.filterRx, (_) {
      if (isEventTab) refreshCurrent();
    });
    ever(_jobFilterService.filterRx, (_) {
      if (isJobTab) refreshCurrent();
    });
    ever(_eventSortingType, (_) {
      if (isEventTab) refreshCurrent();
    });
    ever(_jobSortingType, (_) {
      if (isJobTab) refreshCurrent();
    });

    checkNewNotification();
  }

  @override
  void onClose() {
    searchTextEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> refreshCurrent() async {
    if (!Get.find<AuthService>().isLoggined()) return;

    if (isEventTab) {
      await fetchNextEventPage(clearPage: true);
      return;
    }
    await fetchNextJobPage(clearPage: true);
  }

  Future<void> onPullToRefresh() async {
    await refreshCurrent();
    await checkNewNotification();
  }

  void scrollUpBookmarkList() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void resetCurrentFilter() {
    if (isEventTab) {
      _eventFilterService.resetFilter(false);
      return;
    }
    _jobFilterService.resetFilter();
  }

  void openCurrentFilterPage() {
    Get.toNamed(isEventTab ? Routes.SEARCH_FILTER : Routes.JOB_FILTER);
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
    _hasNewNotification.value = notiList.isNotEmpty && !notiList.first.isRead;
  }

  Future<void> openNotificationsPage() async {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    await Get.toNamed(Routes.NOTIFICATIONS);
    checkNewNotification();
  }

  Future<void> fetchNextEventPage({bool clearPage = false}) async {
    if (!Get.find<AuthService>().isLoggined()) return;
    if (!clearPage && eventPagingState.isLoading) return;

    await _eventPageFetchLock.synchronized(
      () async => _fetchNextEventPage(clearPage: clearPage),
    );
  }

  Future<void> _fetchNextEventPage({bool clearPage = false}) async {
    if (clearPage) _eventOnlyFinishedMode = false;

    eventPagingState = eventPagingState.copyWith(
      isLoading: true,
      error: null,
      keys: clearPage ? null : const Omit(),
      pages: clearPage ? null : const Omit(),
    );

    final filter = _eventFilterService.filter;
    final currentKeys = clearPage
        ? <String?>[]
        : List<String?>.from(eventPagingState.keys ?? const <String?>[]);
    final currentPages = clearPage
        ? <List<Rx<Event>>>[]
        : List<List<Rx<Event>>>.from(
            eventPagingState.pages ?? const <List<Rx<Event>>>[],
          );
    final pageKey = currentKeys.isEmpty ? null : currentKeys.last;

    if (!_eventOnlyFinishedMode &&
        pageKey == null &&
        filter.showEnded &&
        currentKeys.isNotEmpty) {
      _eventOnlyFinishedMode = true;
    }

    final types = filter.categories
        .map(EventType.getByDisplayName)
        .toList(growable: false);

    var hasError = false;
    try {
      final reqResult = await Get.find<ApiClient>().getEvents(
        finished: _eventOnlyFinishedMode,
        bookmarked: true,
        cursor: pageKey,
        size: _eventPageSize,
        field: eventSortingType.field,
        searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
        hostId: filter.host?.id,
        types: types,
      );

      if (reqResult is! RequestSuccess<EventsResponse>) {
        throw _BookmarkRequestFailure(reqResult as RequestFail);
      }

      final response = reqResult.data;
      final pageInfo = response.pageInfo;
      final hasNext = filter.showEnded
          ? (_eventOnlyFinishedMode ? pageInfo.hasNext : true)
          : pageInfo.hasNext;

      eventPagingState = eventPagingState.copyWith(
        keys: [...currentKeys, pageInfo.nextCursor],
        pages: [
          ...currentPages,
          List<Rx<Event>>.generate(
            response.events.length,
            (i) => Rx(response.events[i]),
          ),
        ],
        hasNextPage: hasNext,
      );
    } catch (e, st) {
      hasError = true;
      if (kDebugMode && e is _BookmarkRequestFailure) {
        AppUtils.showSnackBar(
          '북마크한 행사 목록을 불러오지 못했습니다: ${e.fail.serverFail?.message ?? ''}',
        );
      }
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    } finally {
      if (hasError) {
        eventPagingState = eventPagingState.copyWith(
          keys: clearPage ? [] : const Omit(),
          pages: clearPage ? [] : const Omit(),
          error: true,
        );
      }
      eventPagingState = eventPagingState.copyWith(isLoading: false);
    }
  }

  Future<void> fetchNextJobPage({bool clearPage = false}) async {
    if (!Get.find<AuthService>().isLoggined()) return;
    if (!clearPage && jobPagingState.isLoading) return;

    await _jobPageFetchLock.synchronized(
      () async => _fetchNextJobPage(clearPage: clearPage),
    );
  }

  Future<void> _fetchNextJobPage({bool clearPage = false}) async {
    jobPagingState = jobPagingState.copyWith(
      isLoading: true,
      error: null,
      keys: clearPage ? null : const Omit(),
      pages: clearPage ? null : const Omit(),
    );

    final filter = _jobFilterService.filter;
    final currentKeys = clearPage
        ? <String?>[]
        : List<String?>.from(jobPagingState.keys ?? const <String?>[]);
    final currentPages = clearPage
        ? <List<Rx<JobPosting>>>[]
        : List<List<Rx<JobPosting>>>.from(
            jobPagingState.pages ?? const <List<Rx<JobPosting>>>[],
          );
    final pageKey = currentKeys.isEmpty ? null : currentKeys.last;

    var hasError = false;
    try {
      var requestCursor = pageKey;
      var nextCursor = pageKey;
      var hasNext = false;
      final jobs = <JobPosting>[];
      final requiresLocalFiltering = _requiresLocalFiltering(filter);
      final requestSize = requiresLocalFiltering
          ? _localFilterJobPageSize
          : _jobPageSize;

      do {
        final previousCursor = requestCursor;
        final reqResult = await Get.find<ApiClient>().getJobPostings(
          bookmarked: true,
          cursor: requestCursor,
          size: requestSize,
          field: jobSortingType.field,
          searchKeyword: searchQuery.isEmpty ? null : searchQuery.value,
          workRegions: const [],
          employmentTypes: const [],
        );

        if (reqResult is! RequestSuccess<JobPostingsResponse>) {
          throw _BookmarkRequestFailure(reqResult as RequestFail);
        }

        final response = reqResult.data;
        final pageInfo = response.pageInfo;
        jobs.addAll(
          response.jobs.where((job) => JobFilterMatcher.matches(job, filter)),
        );
        nextCursor = pageInfo.nextCursor;
        hasNext = pageInfo.hasNext && nextCursor != previousCursor;
        requestCursor = nextCursor;
      } while (jobs.isEmpty && hasNext && requiresLocalFiltering);

      jobPagingState = jobPagingState.copyWith(
        keys: [...currentKeys, nextCursor],
        pages: [
          ...currentPages,
          List<Rx<JobPosting>>.generate(jobs.length, (i) => Rx(jobs[i])),
        ],
        hasNextPage: hasNext,
      );
    } catch (e, st) {
      hasError = true;
      if (kDebugMode && e is _BookmarkRequestFailure) {
        AppUtils.showSnackBar(
          '북마크한 채용공고를 불러오지 못했습니다: ${e.fail.serverFail?.message ?? ''}',
        );
      }
      FirebaseCrashlytics.instance.recordError(e, st, fatal: false);
    } finally {
      if (hasError) {
        jobPagingState = jobPagingState.copyWith(
          keys: clearPage ? [] : const Omit(),
          pages: clearPage ? [] : const Omit(),
          error: true,
        );
      }
      jobPagingState = jobPagingState.copyWith(isLoading: false);
    }
  }

  Future<void> unbookmarkEvent(Rx<Event> eventRx) async {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    final previous = eventRx.value;
    await Get.find<HomeViewController>().onBookmarkButtonClick(eventRx);

    if (!eventRx.value.isBookmarked) {
      _removeEvent(previous.id);
      _refreshHomeList();
    }
  }

  Future<void> unbookmarkJob(Rx<JobPosting> jobRx) async {
    if (!Get.find<AuthService>().isLoggined()) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    final user = await _ensureAppUserLoaded();
    if (user == null) return;

    final previous = jobRx.value;
    jobRx.value = previous.copyWith(isBookmarked: false);

    final result = await Get.find<ApiClient>().toggleJobBookmark(previous.id);
    if (result is RequestSuccess<bool>) {
      if (result.data) {
        jobRx.value = previous.copyWith(isBookmarked: true);
        return;
      }
      _removeJob(previous.id);
      _refreshJobList();
      return;
    }

    jobRx.value = previous;
    AppUtils.showSnackBar(
      (result as RequestFail).serverFail?.message ?? '북마크를 수정하지 못했습니다.',
    );
  }

  void openJobDetail(Rx<JobPosting> jobRx) {
    Get.toNamed(Routes.JOB_DETAIL, arguments: {'jobRx': jobRx});
  }

  void _removeEvent(int eventId) {
    final pages = eventPagingState.pages;
    if (pages == null) return;

    eventPagingState = eventPagingState.copyWith(
      pages: pages
          .map(
            (page) =>
                page.where((eventRx) => eventRx.value.id != eventId).toList(),
          )
          .toList(),
    );
  }

  void _removeJob(int jobId) {
    final pages = jobPagingState.pages;
    if (pages == null) return;

    jobPagingState = jobPagingState.copyWith(
      pages: pages
          .map(
            (page) => page.where((jobRx) => jobRx.value.id != jobId).toList(),
          )
          .toList(),
    );
  }

  void _refreshHomeList() {
    if (!Get.isRegistered<HomeViewController>()) return;

    unawaited(Get.find<HomeViewController>().fetchNextPage(clearPage: true));
  }

  void _refreshJobList() {
    if (!Get.isRegistered<JobViewController>()) return;

    unawaited(Get.find<JobViewController>().fetchNextPage(clearPage: true));
  }

  Future<AppUser?> _ensureAppUserLoaded() async {
    final user = await Get.find<AuthService>().ensureAppUserLoaded();
    if (user != null) return user;

    AppUtils.showSnackBar('사용자 정보를 불러오지 못했어요. 다시 시도해 주세요.');
    return null;
  }

  bool _requiresLocalFiltering(JobFilter filter) {
    return JobFilterMatcher.requiresLocalFiltering(filter);
  }
}

class _BookmarkRequestFailure implements Exception {
  final RequestFail fail;

  const _BookmarkRequestFailure(this.fail);
}
