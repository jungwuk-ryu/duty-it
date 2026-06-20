// ignore_for_file: invalid_annotation_target

import 'package:duty_it/app/core/models/event.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

AppNotification appNotificationFromJson(String str) =>
    AppNotification.fromJson(json.decode(str));

String appNotificationToJson(AppNotification data) =>
    json.encode(data.toJson());

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    required String type,
    required bool isRead,
    @JsonKey(readValue: _readEvent) Event? event,
    @JsonKey(readValue: _readJobPosting) JobPosting? jobPosting,
    DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

Object? _readEvent(Map json, String key) {
  final value = json[key];
  if (value != null) return value;

  final target = json['target'];
  if (target is Map) return target['event'];

  return null;
}

Object? _readJobPosting(Map json, String key) {
  final value = json[key];
  if (value != null) return value;

  final target = json['target'];
  if (target is Map) return target['jobPosting'];

  return null;
}
