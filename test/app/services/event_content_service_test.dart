import 'package:duty_it/app/services/event_content_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'reads the web summary as plain text from the public content route',
    () async {
      http.Request? capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          '{"body":"첫째 줄\\n둘째 줄"}',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final service = EventContentService(client: client);

      final result = await service.fetch(42);

      expect(result.availability, EventContentAvailability.available);
      expect(result.body, '첫째 줄\n둘째 줄');
      expect(
        capturedRequest?.url.toString(),
        'https://www.dutyit.net/api/events/42/content',
      );
      expect(capturedRequest?.headers['accept'], 'application/json');
      expect(capturedRequest?.headers.containsKey('authorization'), isFalse);
    },
  );

  test('does not show a summary when the web has none', () async {
    final service = EventContentService(
      client: MockClient((_) async => http.Response('{"body":null}', 200)),
    );

    expect(
      (await service.fetch(42)).availability,
      EventContentAvailability.unavailable,
    );
  });

  test(
    'treats unavailable routes and malformed responses as retryable failures',
    () async {
      final missingRoute = EventContentService(
        client: MockClient((_) async => http.Response('Not Found', 404)),
      );
      final malformed = EventContentService(
        client: MockClient((_) async => http.Response('{"body":17}', 200)),
      );

      expect(
        (await missingRoute.fetch(42)).availability,
        EventContentAvailability.failed,
      );
      expect(
        (await malformed.fetch(42)).availability,
        EventContentAvailability.failed,
      );
    },
  );
}
