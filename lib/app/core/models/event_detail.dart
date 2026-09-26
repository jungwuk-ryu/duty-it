import 'package:duty_it/app/core/models/event.dart';

/// Additional fields returned by the public event detail endpoint.
class EventDetail {
  final Event event;
  final String status;
  final int viewCount;

  const EventDetail({
    required this.event,
    required this.status,
    required this.viewCount,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) => EventDetail(
    event: Event.fromJson(json),
    status: json['eventStatus'] as String? ?? 'EVENT_WAITING',
    viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  );
}
