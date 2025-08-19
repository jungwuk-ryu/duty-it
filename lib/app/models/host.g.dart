// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Host _$HostFromJson(Map<String, dynamic> json) => _Host(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  thumbnail: json['thumbnail'] as String,
);

Map<String, dynamic> _$HostToJson(_Host instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumbnail': instance.thumbnail,
};
