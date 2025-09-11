// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmSettings _$AlarmSettingsFromJson(Map<String, dynamic> json) =>
    _AlarmSettings(
      push: json['push'] as bool? ?? false,
      bookmark: json['bookmark'] as bool? ?? false,
      calendar: json['calendar'] as bool? ?? false,
      marketing: json['marketing'] as bool? ?? false,
    );

Map<String, dynamic> _$AlarmSettingsToJson(_AlarmSettings instance) =>
    <String, dynamic>{
      'push': instance.push,
      'bookmark': instance.bookmark,
      'calendar': instance.calendar,
      'marketing': instance.marketing,
    };
