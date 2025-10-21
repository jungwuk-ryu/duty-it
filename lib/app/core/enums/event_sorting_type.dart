import 'package:duty_it/app/core/enums/sort_direction.dart';

enum EventSortingType {
  //ID, NAME, START_DATE, RECRUITMENT_DEADLINE, VIEW_COUNT, CREATED_AT
  latest('최신 등록순', '최신순', 'ID', SortDirection.DESC),
  eventStartSoon('행사 날짜 임박순', '행사 날짜', 'START_DATE', SortDirection.ASC),
  closingSoon('모집 마감 임박순', '모집 마감', 'RECRUITMENT_DEADLINE', SortDirection.ASC),
  popular('인기순', '인기순', 'VIEW_COUNT', SortDirection.DESC);

  final String displayName;
  final String shortName; 
  final String field;
  final SortDirection sortDirection;

  const EventSortingType(this.displayName, this.shortName, this.field, this.sortDirection);

  static EventSortingType fromName(String name) {
    try {
    return EventSortingType.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return EventSortingType.values[0];
    }
  }
}