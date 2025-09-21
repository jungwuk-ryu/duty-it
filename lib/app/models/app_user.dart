import 'package:duty_it/app/models/alarm_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

@freezed
abstract class AppUser with _$AppUser {
    const factory AppUser({
        required int id,
        @Default("?") String email,
        @Default("?") String nickname,
        @Default(false) bool autoAddBookmarkToCalendar,
        @Default(AlarmSettings()) AlarmSettings alarmSettings,
        //required DateTime createdAt,
        //required DateTime updatedAt,
    }) = _AppUser;

    factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
