// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fcm_notification.freezed.dart';
part 'fcm_notification.g.dart';

FcmNotification fcmNotificationFromJson(String str) => FcmNotification.fromJson(json.decode(str));

String fcmNotificationToJson(FcmNotification data) => json.encode(data.toJson());

@freezed
abstract class FcmNotification with _$FcmNotification {
    const factory FcmNotification({
        required String id,
        required String title,
        required String body,
        //required Map data,
        required DateTime timestamp,
        @Default(false) bool read,
    }) = _FcmNotification;

    factory FcmNotification.fromJson(Map<String, dynamic> json) => _$FcmNotificationFromJson(json);

    factory FcmNotification.fromRemoteMessage(RemoteMessage rm) {
      String id = rm.messageId ?? '${DateTime.now().microsecondsSinceEpoch}';
      String title = rm.notification?.title ?? "";
      String body = rm.notification?.body ?? "";
      //Map data = rm.data;
      DateTime timestamp = rm.sentTime ?? DateTime.now();

      return FcmNotification(id: id, title: title, body: body, timestamp: timestamp);
    }
}