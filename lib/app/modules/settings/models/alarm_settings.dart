// To parse this JSON data, do
//
//     final alarmSettings = alarmSettingsFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'alarm_settings.freezed.dart';
part 'alarm_settings.g.dart';

AlarmSettings alarmSettingsFromJson(String str) => AlarmSettings.fromJson(json.decode(str));

String alarmSettingsToJson(AlarmSettings data) => json.encode(data.toJson());

@freezed
abstract class AlarmSettings with _$AlarmSettings {
    const factory AlarmSettings({
        @Default(false) bool push,
        @Default(false) bool bookmark,
        @Default(false) bool calendar,
        @Default(false) bool marketing,
    }) = _AlarmSettings;

    factory AlarmSettings.fromJson(Map<String, dynamic> json) => _$AlarmSettingsFromJson(json);
}
