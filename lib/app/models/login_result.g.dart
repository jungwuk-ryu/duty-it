// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => _LoginResult(
  accessToken: json['accessToken'] as String,
  tokenType: json['tokenType'] as String? ?? "Bearer",
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  isNewUser: json['isNewUser'] as bool,
);

Map<String, dynamic> _$LoginResultToJson(_LoginResult instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
      'user': instance.user,
      'isNewUser': instance.isNewUser,
    };
