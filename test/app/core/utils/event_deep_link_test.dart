import 'package:duty_it/app/core/utils/event_deep_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'opens canonical links and Safari app-button links for the same event',
    () {
      for (final value in [
        'https://www.dutyit.net/events/811',
        'https://www.dutyit.net/events/811/?utm_source=share#detail',
        'https://www.dutyit.net/events/00811',
        'dutyit://events/811',
        'dutyit://events/811/',
      ]) {
        expect(eventIdFromDeepLink(Uri.parse(value)), 811, reason: value);
      }
    },
  );

  test('ignores unrelated routes, malformed IDs, and untrusted hosts', () {
    for (final value in [
      'https://www.dutyit.net/events',
      'https://www.dutyit.net/events/0',
      'https://www.dutyit.net/events/-811',
      'https://www.dutyit.net/events/811.5',
      'https://www.dutyit.net/events/811/extra',
      'https://www.dutyit.net/events/9007199254740992',
      'https://www.dutyit.net/visitEvent/811',
      'https://www.dutyit.net/jobs/811',
      'http://www.dutyit.net/events/811',
      'https://example.com/events/811',
      'https://www.dutyit.net.evil.example/events/811',
      'https://user@www.dutyit.net/events/811',
      'https://www.dutyit.net:8080/events/811',
      'dutyit://jobs/811',
      'dutyit://events/811/extra',
      'dutyit://events:8080/811',
    ]) {
      expect(eventIdFromDeepLink(Uri.parse(value)), isNull, reason: value);
    }
  });
}
