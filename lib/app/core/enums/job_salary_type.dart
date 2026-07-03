import 'package:json_annotation/json_annotation.dart';

enum JobSalaryType {
  @JsonValue('ANNUAL')
  annual('연봉'),
  @JsonValue('MONTHLY')
  monthly('월급'),
  @JsonValue('HOURLY')
  hourly('시급'),
  unknown('');

  final String displayName;

  const JobSalaryType(this.displayName);
}
