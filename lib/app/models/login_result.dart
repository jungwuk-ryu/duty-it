import 'package:duty_it/app/models/app_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_result.freezed.dart';
part 'login_result.g.dart';

LoginResult loginResultFromJson(String str) => LoginResult.fromJson(json.decode(str));

String loginResultToJson(LoginResult data) => json.encode(data.toJson());

@freezed
abstract class LoginResult with _$LoginResult {
    const factory LoginResult({
        required String accessToken,
        @Default("Bearer") String tokenType,
        required AppUser user,
        @Default(false) bool isNewUser,
    }) = _LoginResult;

    factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
}
