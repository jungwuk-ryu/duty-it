import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'server_fail.freezed.dart';
part 'server_fail.g.dart';

ServerFail serverFailFromJson(String str) => ServerFail.fromJson(json.decode(str));

String serverFailToJson(ServerFail data) => json.encode(data.toJson());

@freezed
abstract class ServerFail with _$ServerFail {
    const factory ServerFail({
        @Default("?") String code,
        @Default("no message") String message,
        required DateTime timestamp,
    }) = _ServerFail;

    factory ServerFail.fromJson(Map<String, dynamic> json) => _$ServerFailFromJson(json);
}
