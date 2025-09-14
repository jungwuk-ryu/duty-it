// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String? ?? "?",
  nickname: json['nickname'] as String? ?? "?",
  autoAddBookmarkToCalendar:
      json['autoAddBookmarkToCalendar'] as bool? ?? false,
  alarmSettings: json['alarmSettings'] == null
      ? const AlarmSettings()
      : AlarmSettings.fromJson(json['alarmSettings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'nickname': instance.nickname,
  'autoAddBookmarkToCalendar': instance.autoAddBookmarkToCalendar,
  'alarmSettings': instance.alarmSettings.toJson(),
};
