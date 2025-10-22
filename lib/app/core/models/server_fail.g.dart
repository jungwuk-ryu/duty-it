// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_fail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerFail _$ServerFailFromJson(Map<String, dynamic> json) => _ServerFail(
  code: json['code'] as String? ?? "?",
  message: json['message'] as String? ?? "no message",
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ServerFailToJson(_ServerFail instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };
