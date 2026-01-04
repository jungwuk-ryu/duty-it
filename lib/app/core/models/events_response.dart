// To parse this JSON data, do
//
//     final eventsResponse = eventsResponseFromJson(jsonString);

import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/events_page_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'events_response.freezed.dart';
part 'events_response.g.dart';

EventsResponse eventsResponseFromJson(String str) => EventsResponse.fromJson(json.decode(str));

String eventsResponseToJson(EventsResponse data) => json.encode(data.toJson());

@freezed
abstract class EventsResponse with _$EventsResponse {
    const factory EventsResponse({
        @JsonKey(name: 'content') required List<Event> events,
        required EventsPageInfo pageInfo,
        @JsonKey(includeFromJson: false, includeToJson: false) String? reqUrl
    }) = _EventsResponse;

    factory EventsResponse.fromJson(Map<String, dynamic> json) => _$EventsResponseFromJson(json);
}
