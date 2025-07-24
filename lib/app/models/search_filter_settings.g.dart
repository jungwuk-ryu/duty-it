// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchFilterSettings _$SearchFilterSettingsFromJson(
  Map<String, dynamic> json,
) => _SearchFilterSettings(
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toSet() ??
      const <String>{},
  host: json['host'] as String?,
  showEnded: json['showEnded'] as bool? ?? true,
);

Map<String, dynamic> _$SearchFilterSettingsToJson(
  _SearchFilterSettings instance,
) => <String, dynamic>{
  'categories': instance.categories.toList(),
  'host': instance.host,
  'showEnded': instance.showEnded,
};
