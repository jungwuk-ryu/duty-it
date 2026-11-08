import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/event_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('event countdown changes at midnight in Korea', () {
    final eventDate = DateTime(2026, 9, 27);

    expect(
      AppUtils.daysUntilKstDate(
        eventDate,
        now: DateTime.utc(2026, 9, 26, 14, 59),
      ),
      1,
    );
    expect(
      AppUtils.daysUntilKstDate(eventDate, now: DateTime.utc(2026, 9, 26, 15)),
      0,
    );
  });

  test(
    'midnight events show the same Seoul day and time for each API format',
    () {
      final now = DateTime.parse('2026-11-06T23:00:00+09:00');
      for (final timestamp in [
        '2026-11-07T00:30:00+09:00',
        '2026-11-06T15:30:00Z',
        '2026-11-06T10:30:00-05:00',
        '2026-11-07T00:30:00',
      ]) {
        final start = Event.fromJson({'id': 1, 'startAt': timestamp}).startAt!;
        expect(
          start.seoulWallTime,
          DateTime.utc(2026, 11, 7, 0, 30),
          reason: timestamp,
        );
        expect(
          AppUtils.daysUntilKstDate(start, now: now),
          1,
          reason: timestamp,
        );
        expect(
          start.eventInstantUtc,
          DateTime.utc(2026, 11, 6, 15, 30),
          reason: timestamp,
        );
      }
    },
  );

  test(
    'offset-free event time survives device DST gaps and cache round trips',
    () {
      // 02:30 does not exist in Los Angeles on this day; it does in Seoul.
      final event = Event.fromJson({
        'id': 1,
        'startAt': '2026-03-08T02:30:00',
        'endAt': '2026-03-09',
      });
      expect(event.startAt, DateTime.utc(2026, 3, 7, 17, 30));
      expect(event.endAt, DateTime.utc(2026, 3, 8, 15));
      expect(Event.fromJson(event.toJson()), event);
    },
  );

  test('image URLs require an HTTP host', () {
    expect(AppUtils.isHttpUrl(''), isFalse);
    expect(AppUtils.isHttpUrl('/uploads/poster.png'), isFalse);
    expect(
      AppUtils.isHttpUrl('https://api.dutyit.net/uploads/poster.png'),
      isTrue,
    );
  });
}
