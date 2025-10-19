import 'package:duty_it/app/models/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

AppNotification appNotificationFromJson(String str) => AppNotification.fromJson(json.decode(str));

String appNotificationToJson(AppNotification data) => json.encode(data.toJson());

@freezed
abstract class AppNotification with _$AppNotification {
    const factory AppNotification({
        required int id,
        required String type,
        Event? event,
        DateTime? createdAt,
    }) = _AppNotification;

    factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
