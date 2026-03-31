import 'package:json_annotation/json_annotation.dart';

enum WorkRegion {
  @JsonValue('SEOUL')
  seoul('서울'),
  @JsonValue('BUSAN')
  busan('부산'),
  @JsonValue('DAEGU')
  daegu('대구'),
  @JsonValue('INCHEON')
  incheon('인천'),
  @JsonValue('GWANGJU')
  gwangju('광주'),
  @JsonValue('DAEJEON')
  daejeon('대전'),
  @JsonValue('ULSAN')
  ulsan('울산'),
  @JsonValue('SEJONG')
  sejong('세종'),
  @JsonValue('GYEONGGI')
  gyeonggi('경기'),
  @JsonValue('GANGWON')
  gangwon('강원'),
  @JsonValue('CHUNGBUK')
  chungbuk('충북'),
  @JsonValue('CHUNGNAM')
  chungnam('충남'),
  @JsonValue('JEONBUK')
  jeonbuk('전북'),
  @JsonValue('JEONNAM')
  jeonnam('전남'),
  @JsonValue('GYEONGBUK')
  gyeongbuk('경북'),
  @JsonValue('GYEONGNAM')
  gyeongnam('경남'),
  @JsonValue('JEJU')
  jeju('제주'),
  @JsonValue('ETC')
  etc('기타'),
  unknown('');

  final String displayName;

  const WorkRegion(this.displayName);
}
