class SortingType {
  final String displayName;
  final String shortName;

  SortingType(this.displayName, this.shortName);

  @override
  operator == (other) { //TODO: 나중엔 ID 비교로 바꾸어야 합니다.
    if (other is! SortingType) return false;
    return other.displayName == displayName;
  }
  
  @override
  int get hashCode => displayName.hashCode; //TODO: 나중엔 ID의 hashcode를 반환해야합니다.
  
}