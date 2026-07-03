// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      event: _readEvent(json, 'event') == null
          ? null
          : Event.fromJson(_readEvent(json, 'event') as Map<String, dynamic>),
      jobPosting: _readJobPosting(json, 'jobPosting') == null
          ? null
          : JobPosting.fromJson(
              _readJobPosting(json, 'jobPosting') as Map<String, dynamic>,
            ),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'isRead': instance.isRead,
      'event': instance.event?.toJson(),
      'jobPosting': instance.jobPosting?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
