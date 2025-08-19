// ignore_for_file: constant_identifier_names

enum EventType {
  CONFERENCE('컨퍼런스/학술대회'),
  SEMINAR('세미나'),
  WEBINAR('웨비나'),
  WORKSHOP('워크숍'),
  CONTEST('콘테스트'),
  ETC('기타');
   
  final String displayName;
  const EventType(this.displayName);
}