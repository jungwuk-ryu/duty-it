// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_page_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CursorPageInfo _$CursorPageInfoFromJson(Map<String, dynamic> json) =>
    _CursorPageInfo(
      hasNext: json['hasNext'] as bool,
      nextCursor: json['nextCursor'] as String?,
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$CursorPageInfoToJson(_CursorPageInfo instance) =>
    <String, dynamic>{
      'hasNext': instance.hasNext,
      'nextCursor': instance.nextCursor,
      'pageSize': instance.pageSize,
    };
