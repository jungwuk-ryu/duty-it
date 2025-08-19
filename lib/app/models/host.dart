// To parse this JSON data, do
//
//     final host = hostFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'host.freezed.dart';
part 'host.g.dart';

Host hostFromJson(String str) => Host.fromJson(json.decode(str));

String hostToJson(Host data) => json.encode(data.toJson());

@freezed
abstract class Host with _$Host {
    const factory Host({
        required int id,
        required String name,
        required String thumbnail,
    }) = _Host;

    factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);
}
