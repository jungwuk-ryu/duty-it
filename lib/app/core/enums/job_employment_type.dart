import 'package:json_annotation/json_annotation.dart';

enum JobEmploymentType {
  @JsonValue('FULL_TIME')
  fullTime('정규직', '정규직 (기간에 정함이 없는 근로계약)'),
  @JsonValue('CONTRACT')
  contract('계약직', '계약직 (기간에 정함이 있는 근로계약)'),
  @JsonValue('PART_TIME')
  partTime('아르바이트', '아르바이트'),
  @JsonValue('DISPATCH')
  dispatch('파견직', '파견직'),
  @JsonValue('INTERN')
  intern('인턴', '인턴'),
  @JsonValue('ETC')
  etc('기타', '기타'),
  unknown('', '');

  final String displayName;
  final String filterDisplayName;

  const JobEmploymentType(this.displayName, this.filterDisplayName);

  String get apiValue {
    switch (this) {
      case JobEmploymentType.fullTime:
        return 'FULL_TIME';
      case JobEmploymentType.contract:
        return 'CONTRACT';
      case JobEmploymentType.partTime:
        return 'PART_TIME';
      case JobEmploymentType.dispatch:
        return 'DISPATCH';
      case JobEmploymentType.intern:
        return 'INTERN';
      case JobEmploymentType.etc:
      case JobEmploymentType.unknown:
        return 'ETC';
    }
  }
}
