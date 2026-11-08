import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/utils/event_time.dart';

// /visitEvent is already present in Apple's cached domain association file.
// Only marked links open the native detail; existing organizer links stay intact.
String eventShareUrl(int eventId) =>
    'https://www.dutyit.net/visitEvent/$eventId?openIn=app';

class EventCalendarDraft {
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;

  const EventCalendarDraft({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
  });

  static EventCalendarDraft? fromEvent(Event event) {
    if (event.startAt == null) return null;
    final start = event.startAt!.eventInstantUtc;
    final suppliedEnd = event.endAt?.eventInstantUtc;
    return EventCalendarDraft(
      title: event.title,
      description: '주최: ${event.host.name}\n행사 상세: ${eventShareUrl(event.id)}',
      start: start,
      end: suppliedEnd != null && suppliedEnd.isAfter(start)
          ? suppliedEnd
          : start.add(const Duration(hours: 1)),
    );
  }
}
