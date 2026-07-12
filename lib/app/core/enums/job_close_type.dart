import 'package:json_annotation/json_annotation.dart';

enum JobCloseType {
  @JsonValue('FIXED')
  fixed('마감일 지정'),
  @JsonValue('ON_HIRE')
  onHire('채용시 마감'),
  @JsonValue('ONGOING')
  ongoing('상시채용'),
  unknown('');

  final String displayName;

  const JobCloseType(this.displayName);
}
