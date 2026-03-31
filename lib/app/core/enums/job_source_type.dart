import 'package:json_annotation/json_annotation.dart';

enum JobSourceType {
  @JsonValue('SARAMIN')
  saramin('사람인'),
  @JsonValue('WORK24')
  work24('고용24'),
  unknown('');

  final String displayName;

  const JobSourceType(this.displayName);
}
