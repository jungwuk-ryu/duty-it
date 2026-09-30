import 'dart:async';
import 'dart:io';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/events_page_info.dart';
import 'package:duty_it/app/core/models/events_response.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/modules/home/cache/home_view_cache.dart';
import 'package:duty_it/app/modules/home/controllers/home_view_controller.dart';
import 'package:duty_it/app/modules/home/widgets/home_header.dart';
import 'package:duty_it/app/modules/event/widgets/event_host_card.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/search_filter/models/search_filter.dart';
import 'package:duty_it/app/services/search_filter/search_filter_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class _Analytics extends Fake implements FirebaseAnalytics {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {}
}

class _Auth extends AuthService {
  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  bool isLoggined() => true;
}

class _Api extends ApiClient {
  final requests =
      <
        ({
          int? hostId,
          String? search,
          bool bookmarked,
          bool finished,
          List<EventType> types,
          String? cursor,
        })
      >[];
  final responses = <Completer<RequestResult<EventsResponse>>>[];

  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<RequestResult<EventsResponse>> getEvents({
    String? cursor,
    bool finished = false,
    bool bookmarked = false,
    int size = 10,
    String field = 'CREATED_AT',
    required List<EventType> types,
    int? hostId,
    String? searchKeyword,
  }) {
    requests.add((
      hostId: hostId,
      search: searchKeyword,
      bookmarked: bookmarked,
      finished: finished,
      types: types,
      cursor: cursor,
    ));
    final response = Completer<RequestResult<EventsResponse>>();
    responses.add(response);
    return response.future;
  }

  void complete(int index, List<Event> events) {
    responses[index].complete(
      RequestSuccess(
        EventsResponse(
          events: events,
          pageInfo: const EventsPageInfo(
            hasNext: false,
            nextCursor: null,
            pageSize: 5,
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProvider = MethodChannel('plugins.flutter.io/path_provider');
  late HomeViewController controller;
  late _Api api;
  late SearchFilterService filters;

  setUpAll(() async {
    final storageDirectory = await Directory.systemTemp.createTemp(
      'duit_host_events_',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          pathProvider,
          (_) async => storageDirectory.path,
        );
    await GetStorage.init(SearchFilterService.storageBoxName);
    await GetStorage.init(HomeViewCache.boxName);
  });

  setUp(() async {
    await GetStorage(SearchFilterService.storageBoxName).erase();
    await GetStorage(HomeViewCache.boxName).erase();
    Get.put<AuthService>(_Auth());
    filters = Get.put(SearchFilterService());
    api = _Api();
    Get.put<ApiClient>(api);
    controller = HomeViewController(analytics: _Analytics());
    controller.loadEventListFromCache = false;
  });

  tearDown(() async {
    controller.onClose();
    Get.reset();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProvider, null);
  });

  const host = Host(id: 60, name: '한국재활간호학회');

  test(
    'opens all events from the host without previous search or bookmark filters',
    () async {
      filters.updateFilter(
        const SearchFilter(
          categories: {'세미나'},
          host: Host(id: 134),
          showEnded: false,
        ),
      );
      controller.selectedTab = HomeTab.bookmark;
      controller.searchTextEditingController.text = '이전 검색어';
      controller.searchQuery.value = '이전 검색어';
      controller.onlyFinishedMode = true;

      controller.showHostEvents(host);
      await pumpEventQueue();

      expect(controller.selectedTab, HomeTab.event);
      expect(controller.searchTextEditingController.text, isEmpty);
      expect(filters.filter.host, host);
      expect(filters.filter.showEnded, isTrue);
      expect(api.requests.single.hostId, host.id);
      expect(api.requests.single.search, isNull);
      expect(api.requests.single.types, isEmpty);
      expect(api.requests.single.bookmarked, isFalse);
      expect(api.requests.single.finished, isFalse);
      expect(api.requests.single.cursor, isNull);

      api.complete(0, [const Event(id: 789, host: host)]);
      await pumpEventQueue();
      final finishedPage = controller.fetchNextPage();
      await pumpEventQueue();
      expect(api.requests.last.hostId, host.id);
      expect(api.requests.last.finished, isTrue);
      api.complete(1, [const Event(id: 640, host: host)]);
      await finishedPage;
      await pumpEventQueue();
    },
  );

  test(
    'discards a pending unfiltered response after selecting a host',
    () async {
      final pending = controller.fetchNextPage(clearPage: true);
      await pumpEventQueue();
      expect(api.requests.single.hostId, isNull);

      controller.showHostEvents(host);
      api.complete(0, [const Event(id: 790, host: Host(id: 134))]);
      await pending;
      await pumpEventQueue();

      expect(api.requests.last.hostId, host.id);
      expect(controller.pagingState.pages, isNull);
      expect(controller.pagingState.isLoading, isTrue);

      api.complete(1, [const Event(id: 789, host: host)]);
      await pumpEventQueue();
      expect(
        controller.pagingState.pages!.single.single.eventRx.value.host,
        host,
      );
      expect(controller.pagingState.isLoading, isFalse);
    },
  );

  testWidgets(
    'host card exposes a tappable organizer and falls back without a logo',
    (tester) async {
      var tapped = false;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventHostCard(host: host, onTap: () => tapped = true),
          ),
        ),
      );
      expect(find.byIcon(Icons.business_outlined), findsOneWidget);
      expect(find.bySemanticsLabel('${host.name}의 행사 목록 보기'), findsOneWidget);
      await tester.tap(find.text(host.name));
      expect(tapped, isTrue);
      semantics.dispose();
    },
  );

  testWidgets(
    'selected organizer is visible and can be removed from the list',
    (tester) async {
      filters.updateFilter(const SearchFilter(host: host));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: HomeHeader(controller: controller)),
        ),
      );
      expect(find.text(host.name), findsOneWidget);
      await tester.tap(find.byTooltip('주최 필터 해제'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.runAsync(() => pumpEventQueue());
      expect(filters.filter.host, isNull);
      expect(find.text(host.name), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
