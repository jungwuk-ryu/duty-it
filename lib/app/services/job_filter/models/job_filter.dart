import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_filter.freezed.dart';
part 'job_filter.g.dart';

@freezed
abstract class JobFilter with _$JobFilter {
  const factory JobFilter({
    @Default(<WorkRegion>{}) Set<WorkRegion> workRegions,
    @Default(<JobEmploymentType>{}) Set<JobEmploymentType> employmentTypes,
  }) = _JobFilter;

  factory JobFilter.fromJson(Map<String, Object?> json) =>
      _$JobFilterFromJson(json);
}
