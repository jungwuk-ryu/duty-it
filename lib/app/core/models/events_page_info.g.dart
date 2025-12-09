// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventsPageInfo _$EventsPageInfoFromJson(Map<String, dynamic> json) =>
    _EventsPageInfo(
      hasNext: json['hasNext'] as bool,
      nextCursor: json['nextCursor'] as String?,
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$EventsPageInfoToJson(_EventsPageInfo instance) =>
    <String, dynamic>{
      'hasNext': instance.hasNext,
      'nextCursor': instance.nextCursor,
      'pageSize': instance.pageSize,
    };
