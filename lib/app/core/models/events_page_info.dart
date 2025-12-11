// To parse this JSON data, do
//
//     final eventsPageInfo = eventsPageInfoFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'events_page_info.freezed.dart';
part 'events_page_info.g.dart';

EventsPageInfo eventsPageInfoFromJson(String str) => EventsPageInfo.fromJson(json.decode(str));

String eventsPageInfoToJson(EventsPageInfo data) => json.encode(data.toJson());

@freezed
abstract class EventsPageInfo with _$EventsPageInfo {
    const factory EventsPageInfo({
        required bool hasNext,
        required String? nextCursor,
        required int pageSize,
    }) = _EventsPageInfo;

    factory EventsPageInfo.fromJson(Map<String, dynamic> json) => _$EventsPageInfoFromJson(json);
}
