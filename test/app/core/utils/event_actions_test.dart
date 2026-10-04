import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:duty_it/app/core/utils/event_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calendar uses Seoul API time and the canonical event link', () {
    final draft = EventCalendarDraft.fromEvent(
      Event(
        id: 42,
        title: '간호 학술대회',
        host: const Host(id: 1, name: '간호협회'),
        startAt: DateTime(2026, 10, 1, 9),
        endAt: DateTime(2026, 10, 2, 18),
      ),
    )!;
    expect(draft.start, DateTime.utc(2026, 10, 1));
    expect(draft.end, DateTime.utc(2026, 10, 2, 9));
    expect(
      draft.description,
      '주최: 간호협회\n행사 상세: https://www.dutyit.net/events/42',
    );
  });

  test(
    'offset timestamps keep their instant and invalid ends get one hour',
    () {
      final start = DateTime.parse('2026-10-01T09:00:00+09:00');
      for (final end in [
        null,
        start,
        start.subtract(const Duration(hours: 1)),
      ]) {
        final draft = EventCalendarDraft.fromEvent(
          Event(id: 1, startAt: start, endAt: end),
        )!;
        expect(draft.start, DateTime.utc(2026, 10, 1));
        expect(draft.end.difference(draft.start), const Duration(hours: 1));
      }
    },
  );

  test('missing start date cannot invent a calendar event', () {
    expect(EventCalendarDraft.fromEvent(const Event(id: 1)), isNull);
  });
}
