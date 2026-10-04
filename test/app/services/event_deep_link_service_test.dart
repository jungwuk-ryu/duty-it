import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/event_detail.dart';
import 'package:duty_it/app/services/event_deep_link_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

EventDetail _detail(int id, {String status = 'RECRUITING'}) => EventDetail(
  event: Event(id: id),
  status: status,
  viewCount: 0,
);

void main() {
  tearDown(Get.reset);

  test(
    'reselecting the displayed event cancels a slower link to another event',
    () async {
      Get.routing.current = '/events/811';
      addTearDown(() => Get.routing.current = '');
      final response = Completer<RequestResult<EventDetail>>();
      final opened = <int>[];
      final service = EventDeepLinkService(
        fetchDetail: (_) => response.future,
        showDetail: (detail) => opened.add(detail.event.id),
      )..markNavigationReady();
      final pending = service.openEvent(812);
      await service.openEvent(811);
      response.complete(RequestSuccess(_detail(812)));
      await pending;
      expect(opened, isEmpty);
    },
  );

  test(
    'restores app-link handling after an auth reset force-deletes services',
    () async {
      final original = EventDeepLinkService.ensureRegistered();
      expect(EventDeepLinkService.ensureRegistered(), same(original));
      await Get.deleteAll(force: true);
      expect(Get.isRegistered<EventDeepLinkService>(), isFalse);
      final restored = EventDeepLinkService.ensureRegistered();
      expect(Get.isRegistered<EventDeepLinkService>(), isTrue);
      expect(restored, isNot(same(original)));
      expect(Get.find<EventDeepLinkService>(), same(restored));
    },
  );

  test(
    'holds the cold-start link until main navigation and services are ready',
    () async {
      final fetched = <int>[];
      final opened = <int>[];
      final service = EventDeepLinkService(
        fetchDetail: (id) async {
          fetched.add(id);
          return RequestSuccess(_detail(id));
        },
        showDetail: (detail) => opened.add(detail.event.id),
      );
      await service.openEvent(811);
      await service.openEvent(812);
      expect(fetched, isEmpty);
      expect(opened, isEmpty);
      service.markNavigationReady();
      await pumpEventQueue();
      expect(fetched, [812]);
      expect(opened, [812]);
      service.markNavigationReady();
      await pumpEventQueue();
      expect(opened, [812]);
    },
  );

  test(
    'deduplicates an initial-link stream echo and opens the latest warm link',
    () async {
      final responses = <int, Completer<RequestResult<EventDetail>>>{};
      final opened = <int>[];
      final service = EventDeepLinkService(
        fetchDetail: (id) =>
            (responses[id] = Completer<RequestResult<EventDetail>>()).future,
        showDetail: (detail) => opened.add(detail.event.id),
      )..markNavigationReady();
      final first = service.openEvent(811);
      await service.openEvent(811);
      expect(responses.length, 1);
      final next = service.openEvent(812);
      responses[812]!.complete(RequestSuccess(_detail(812)));
      await next;
      responses[811]!.complete(RequestSuccess(_detail(811)));
      await first;
      expect(opened, [812]);
    },
  );

  test(
    'failed or unpublished events stay in the app and can be retried',
    () async {
      final errors = <String>[];
      final opened = <int>[];
      RequestResult<EventDetail> result = RequestFail(null);
      final service = EventDeepLinkService(
        fetchDetail: (_) async => result,
        showDetail: (detail) => opened.add(detail.event.id),
        showError: errors.add,
      )..markNavigationReady();
      await service.openEvent(811);
      result = RequestSuccess(_detail(811, status: 'PENDING'));
      await service.openEvent(811);
      expect(opened, isEmpty);
      expect(errors.length, 2);
      result = RequestSuccess(_detail(811));
      await service.openEvent(811);
      expect(opened, [811]);
    },
  );

  test(
    'closing the service prevents navigation from an unfinished request',
    () async {
      final response = Completer<RequestResult<EventDetail>>();
      final opened = <int>[];
      final service = EventDeepLinkService(
        fetchDetail: (_) => response.future,
        showDetail: (detail) => opened.add(detail.event.id),
      )..markNavigationReady();
      final opening = service.openEvent(811);
      service.onClose();
      response.complete(RequestSuccess(_detail(811)));
      await opening;
      expect(opened, isEmpty);
    },
  );
}
