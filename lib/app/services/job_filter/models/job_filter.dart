import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_filter.freezed.dart';
part 'job_filter.g.dart';

enum JobCareerFilter {
  entry('신입'),
  oneToThree('경력 1~3년'),
  threeToFive('경력 3~5년'),
  fiveToTen('경력 5~10년'),
  tenPlus('경력 10년 이상'),
  noPreference('경력 무관');

  final String displayName;

  const JobCareerFilter(this.displayName);
}

const List<JobEmploymentType> supportedJobFilterEmploymentTypes = [
  JobEmploymentType.fullTime,
  JobEmploymentType.contract,
];

const List<WorkRegion> supportedJobFilterWorkRegions = [
  WorkRegion.seoul,
  WorkRegion.gyeonggi,
  WorkRegion.incheon,
  WorkRegion.daejeon,
  WorkRegion.sejong,
  WorkRegion.chungnam,
  WorkRegion.chungbuk,
  WorkRegion.gwangju,
  WorkRegion.jeonnam,
  WorkRegion.jeonbuk,
  WorkRegion.daegu,
  WorkRegion.gyeongbuk,
  WorkRegion.busan,
  WorkRegion.ulsan,
  WorkRegion.gyeongnam,
  WorkRegion.gangwon,
  WorkRegion.jeju,
];

@freezed
abstract class JobFilter with _$JobFilter {
  const factory JobFilter({
    @Default(<JobCareerFilter>{}) Set<JobCareerFilter> careerFilters,
    @Default(<WorkRegion>{}) Set<WorkRegion> workRegions,
    @Default(<JobEmploymentType>{}) Set<JobEmploymentType> employmentTypes,
    @Default(true) bool showClosed,
  }) = _JobFilter;

  factory JobFilter.fromJson(Map<String, Object?> json) =>
      _$JobFilterFromJson(json);
}
