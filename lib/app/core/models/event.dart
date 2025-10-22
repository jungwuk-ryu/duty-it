// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

import 'package:duty_it/app/core/enums/event_type.dart';
import 'package:duty_it/app/core/models/host.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

@freezed
abstract class Event with _$Event {
  const factory Event({
    required int id,
    @Default("?") String title,
    DateTime? startAt,
    DateTime? endAt,
    DateTime? recruitmentStartAt,
    DateTime? recruitmentEndAt,
    @Default("") String uri,
    @Default("") String thumbnail,
    // ignore: invalid_annotation_target
    @JsonKey(unknownEnumValue: EventType.ETC) @Default(EventType.ETC) EventType eventType,
    @Default(Host(id: 0)) Host host,
    @Default(false) bool isBookmarked,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
