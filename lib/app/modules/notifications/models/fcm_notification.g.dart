// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FcmNotification _$FcmNotificationFromJson(Map<String, dynamic> json) =>
    _FcmNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$FcmNotificationToJson(_FcmNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'timestamp': instance.timestamp.toIso8601String(),
      'read': instance.read,
    };
