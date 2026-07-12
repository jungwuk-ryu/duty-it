import 'package:json_annotation/json_annotation.dart';

enum JobEducationLevel {
  @JsonValue('NONE')
  none('학력무관'),
  @JsonValue('HIGH_SCHOOL')
  highSchool('고졸'),
  @JsonValue('ASSOCIATE')
  associate('전문학사'),
  @JsonValue('BACHELOR')
  bachelor('학사'),
  @JsonValue('MASTER')
  master('석사'),
  @JsonValue('DOCTOR')
  doctor('박사'),
  unknown('');

  final String displayName;

  const JobEducationLevel(this.displayName);
}
