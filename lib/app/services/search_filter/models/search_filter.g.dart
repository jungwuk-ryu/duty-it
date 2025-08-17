// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) =>
    _SearchFilter(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const <String>{},
      host: json['host'] as String?,
      showEnded: json['showEnded'] as bool? ?? true,
    );

Map<String, dynamic> _$SearchFilterToJson(_SearchFilter instance) =>
    <String, dynamic>{
      'categories': instance.categories.toList(),
      'host': instance.host,
      'showEnded': instance.showEnded,
    };
