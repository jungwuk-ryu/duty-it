// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventsResponse _$EventsResponseFromJson(Map<String, dynamic> json) =>
    _EventsResponse(
      events: (json['content'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: EventsPageInfo.fromJson(
        json['pageInfo'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$EventsResponseToJson(_EventsResponse instance) =>
    <String, dynamic>{
      'content': instance.events.map((e) => e.toJson()).toList(),
      'pageInfo': instance.pageInfo.toJson(),
    };
