import 'dart:convert';

import 'package:duty_it/app/services/event_content_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, Object?> availableContent({String eventId = '42'}) => {
  'schemaVersion': 'duit-event-content-api.v1',
  'eventId': eventId,
  'availability': 'available',
  'content': {
    'format': 'text/plain',
    'language': 'ko',
    'body': '첫째 줄\n둘째 줄',
    'generatedAt': '2026-09-09T12:00:00.000Z',
  },
};

http.Response jsonResponse(Object payload) => http.Response.bytes(
  utf8.encode(jsonEncode(payload)),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  test('reads Korean content directly from Surfer without a secret', () async {
    http.Request? capturedRequest;
    final service = EventContentService(
      client: MockClient((request) async {
        capturedRequest = request;
        return jsonResponse(availableContent());
      }),
    );

    final result = await service.fetch(42);

    expect(result.availability, EventContentAvailability.available);
    expect(result.body, '첫째 줄\n둘째 줄');
    expect(
      capturedRequest?.url.toString(),
      'https://surfer.dutyit.net/api/v1/public/duit-events/42/content',
    );
    expect(capturedRequest?.headers['accept'], 'application/json');
    expect(capturedRequest?.headers.containsKey('authorization'), isFalse);
  });

  test('hides the section for an explicit unavailable result', () async {
    final service = EventContentService(
      client: MockClient(
        (_) async => jsonResponse({
          'schemaVersion': 'duit-event-content-api.v1',
          'eventId': '42',
          'availability': 'unavailable',
          'content': null,
        }),
      ),
    );

    final result = await service.fetch(42);

    expect(result.availability, EventContentAvailability.unavailable);
    expect(result.body, isNull);
  });

  test('never shows content returned for a different event', () async {
    final service = EventContentService(
      client: MockClient(
        (_) async => jsonResponse(availableContent(eventId: '43')),
      ),
    );
    expect(
      (await service.fetch(42)).availability,
      EventContentAvailability.failed,
    );
  });

  test('rejects the old web payload and an unsupported schema', () async {
    for (final payload in [
      {'body': '행사 내용'},
      {...availableContent(), 'schemaVersion': 'unknown'},
    ]) {
      final service = EventContentService(
        client: MockClient((_) async => jsonResponse(payload)),
      );
      expect(
        (await service.fetch(42)).availability,
        EventContentAvailability.failed,
      );
    }
  });

  test(
    'treats inconsistent and malformed content as retryable failures',
    () async {
      for (final payload in [
        {...availableContent(), 'availability': 'unavailable'},
        {...availableContent(), 'content': null},
        {
          ...availableContent(),
          'content': {
            'format': 'text/html',
            'language': 'ko',
            'body': '<p>행사 내용</p>',
          },
        },
        {
          ...availableContent(),
          'content': {'format': 'text/plain', 'language': 'ko', 'body': '  '},
        },
        {
          ...availableContent(),
          'content': {'format': 'text/plain', 'language': 'ko', 'body': 17},
        },
      ]) {
        final service = EventContentService(
          client: MockClient((_) async => jsonResponse(payload)),
        );
        expect(
          (await service.fetch(42)).availability,
          EventContentAvailability.failed,
        );
      }
    },
  );

  test('keeps HTTP and transport errors retryable', () async {
    for (final status in [401, 404, 429, 503]) {
      final service = EventContentService(
        client: MockClient((_) async => http.Response('Unavailable', status)),
      );
      expect(
        (await service.fetch(42)).availability,
        EventContentAvailability.failed,
      );
    }
    final service = EventContentService(
      client: MockClient(
        (_) async => throw http.ClientException('Network error'),
      ),
    );
    expect(
      (await service.fetch(42)).availability,
      EventContentAvailability.failed,
    );
  });

  test('rejects invalid event IDs before requesting Surfer', () async {
    var requested = false;
    final service = EventContentService(
      client: MockClient((_) async {
        requested = true;
        return jsonResponse(availableContent());
      }),
    );

    for (final eventId in [0, -1]) {
      expect(
        (await service.fetch(eventId)).availability,
        EventContentAvailability.failed,
      );
    }
    expect(requested, isFalse);
  });
}
