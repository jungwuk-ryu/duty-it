// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fcm_notification.freezed.dart';
part 'fcm_notification.g.dart';

FcmNotification fcmNotificationFromJson(String str) => FcmNotification.fromJson(json.decode(str));

String fcmNotificationToJson(FcmNotification data) => json.encode(data.toJson());

@freezed
abstract class FcmNotification with _$FcmNotification {
    const factory FcmNotification({
        required int id,
        required String title,
        required String body,
        required Map data,
        required DateTime timestamp,
        required bool read,
    }) = _FcmNotification;

    factory FcmNotification.fromJson(Map<String, dynamic> json) => _$FcmNotificationFromJson(json);
}