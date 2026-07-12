enum JobSortingType {
  latest('최신 등록순', '최신순', 'CREATED_AT'),
  closingSoon('마감 임박순', '마감순', 'EXPIRES_AT'),
  salary('급여순', '급여순', 'SALARY');

  final String displayName;
  final String shortName;
  final String field;

  const JobSortingType(this.displayName, this.shortName, this.field);

  static JobSortingType fromName(String name) {
    try {
      return JobSortingType.values.firstWhere((element) => element.name == name);
    } catch (_) {
      return JobSortingType.latest;
    }
  }
}
