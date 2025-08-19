// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  startAt: json['startAt'] == null
      ? null
      : DateTime.parse(json['startAt'] as String),
  endAt: json['endAt'] == null ? null : DateTime.parse(json['endAt'] as String),
  recruitmentStartAt: json['recruitmentStartAt'] == null
      ? null
      : DateTime.parse(json['recruitmentStartAt'] as String),
  recruitmentEndAt: json['recruitmentEndAt'] == null
      ? null
      : DateTime.parse(json['recruitmentEndAt'] as String),
  uri: json['uri'] as String,
  thumbnail: json['thumbnail'] as String,
  eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
  host: Host.fromJson(json['host'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'startAt': instance.startAt?.toIso8601String(),
  'endAt': instance.endAt?.toIso8601String(),
  'recruitmentStartAt': instance.recruitmentStartAt?.toIso8601String(),
  'recruitmentEndAt': instance.recruitmentEndAt?.toIso8601String(),
  'uri': instance.uri,
  'thumbnail': instance.thumbnail,
  'eventType': _$EventTypeEnumMap[instance.eventType]!,
  'host': instance.host,
};

const _$EventTypeEnumMap = {
  EventType.CONFERENCE: 'CONFERENCE',
  EventType.SEMINAR: 'SEMINAR',
  EventType.WEBINAR: 'WEBINAR',
  EventType.WORKSHOP: 'WORKSHOP',
  EventType.CONTEST: 'CONTEST',
  EventType.ETC: 'ETC',
};
