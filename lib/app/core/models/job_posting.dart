// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:duty_it/app/core/enums/job_close_type.dart';
import 'package:duty_it/app/core/enums/job_education_level.dart';
import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/job_salary_type.dart';
import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_posting.freezed.dart';
part 'job_posting.g.dart';

JobPosting jobPostingFromJson(String str) =>
    JobPosting.fromJson(json.decode(str));

String jobPostingToJson(JobPosting data) => json.encode(data.toJson());

@freezed
abstract class JobPosting with _$JobPosting {
  const factory JobPosting({
    required int id,
    @JsonKey(unknownEnumValue: JobSourceType.unknown)
    @Default(JobSourceType.unknown)
    JobSourceType sourceType,
    @Default('?') String title,
    @Default('') String companyName,
    @Default('') String jobCategory,
    @Default('') String location,
    @JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion,
    @Default('') String workDistrict,
    @JsonKey(unknownEnumValue: JobEmploymentType.unknown)
    JobEmploymentType? employmentType,
    @Default('') String careerDescription,
    @JsonKey(unknownEnumValue: JobEducationLevel.unknown)
    JobEducationLevel? educationLevel,
    @Default('') String salaryDescription,
    @JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType,
    @Default('') String postingUrl,
    DateTime? postedAt,
    DateTime? expiresAt,
    @JsonKey(unknownEnumValue: JobCloseType.unknown)
    @Default(JobCloseType.unknown)
    JobCloseType closeType,
    @Default(false) bool isBookmarked,
    DateTime? createdAt,
  }) = _JobPosting;

  factory JobPosting.fromJson(Map<String, dynamic> json) =>
      _$JobPostingFromJson(json);
}
