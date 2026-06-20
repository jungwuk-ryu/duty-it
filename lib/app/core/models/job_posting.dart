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
    @JsonKey(
      readValue: _readSourceType,
      unknownEnumValue: JobSourceType.unknown,
    )
    @Default(JobSourceType.work24)
    JobSourceType sourceType,
    @Default('') String wantedAuthNo,
    @Default(true) bool isActive,
    @JsonKey(readValue: _readTitle) @Default('?') String title,
    @JsonKey(readValue: _readCompanyName) @Default('') String companyName,
    @JsonKey(readValue: _readCompanyAddress) @Default('') String companyAddress,
    @JsonKey(readValue: _readCompanyBusiness)
    @Default('')
    String companyBusiness,
    @JsonKey(readValue: _readJobCategory) @Default('') String jobCategory,
    @Default('') String relJobsNm,
    @Default('') String jobCont,
    @Default('') String receiptCloseDt,
    @JsonKey(readValue: _readEmploymentName) @Default('') String employmentName,
    @JsonKey(readValue: _readLocation) @Default('') String location,
    @JsonKey(unknownEnumValue: WorkRegion.unknown) WorkRegion? workRegion,
    @Default('') String workDistrict,
    @JsonKey(unknownEnumValue: JobEmploymentType.unknown)
    JobEmploymentType? employmentType,
    @JsonKey(readValue: _readCareerDescription)
    @Default('')
    String careerDescription,
    @JsonKey(unknownEnumValue: JobEducationLevel.unknown)
    JobEducationLevel? educationLevel,
    @JsonKey(readValue: _readEducationName) @Default('') String educationName,
    @JsonKey(readValue: _readSalaryDescription)
    @Default('')
    String salaryDescription,
    @JsonKey(unknownEnumValue: JobSalaryType.unknown) JobSalaryType? salaryType,
    @JsonKey(readValue: _readPostingUrl) @Default('') String postingUrl,
    @Default('') String collectPsncnt,
    @Default('') String forLang,
    @Default('') String major,
    @Default('') String certificate,
    @Default('') String mltsvcExcHope,
    @Default('') String compAbl,
    @Default('') String pfCond,
    @Default('') String etcPfCond,
    @Default('') String selMthd,
    @Default('') String rcptMthd,
    @Default('') String submitDoc,
    @Default('') String etcHopeCont,
    @Default('') String nearLine,
    @Default('') String workdayWorkhrCont,
    @Default('') String fourIns,
    @Default('') String retirepay,
    @Default('') String etcWelfare,
    @Default('') String disableCvntl,
    @Default('') String attachFileUrl,
    @Default(<String>[]) List<String> corpAttachList,
    @Default(<String>[]) List<String> keywordList,
    @Default('') String empChargerDpt,
    @Default('') String contactTelno,
    @Default('') String chargerFaxNo,
    DateTime? postedAt,
    DateTime? expiresAt,
    @JsonKey(unknownEnumValue: JobCloseType.unknown)
    @Default(JobCloseType.unknown)
    JobCloseType closeType,
    @Default(false) bool isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JobPosting;

  factory JobPosting.fromJson(Map<String, dynamic> json) =>
      _$JobPostingFromJson(json);
}

Object? _readSourceType(Map json, String key) {
  return json[key] ?? 'WORK24';
}

Object? _readTitle(Map json, String key) {
  return _firstJsonValue(json, [key, 'wantedTitle']);
}

Object? _readCompanyName(Map json, String key) {
  return _firstJsonValue(json, [key]) ??
      _nestedJsonValue(json, 'company', 'corpNm');
}

Object? _readCompanyAddress(Map json, String key) {
  return _firstJsonValue(json, [key]) ??
      _nestedJsonValue(json, 'company', 'corpAddr');
}

Object? _readCompanyBusiness(Map json, String key) {
  return _firstJsonValue(json, [key]) ??
      _nestedJsonValue(json, 'company', 'busiCont');
}

Object? _readJobCategory(Map json, String key) {
  return _firstJsonValue(json, [key, 'jobsNm']);
}

Object? _readLocation(Map json, String key) {
  final location = _firstJsonValue(json, [key]);
  if (location != null) return location;

  final workRegion = json['workRegion'];
  if (workRegion is! String) return workRegion;

  final normalized = workRegion.trim().toUpperCase();
  if (_workRegionCodes.contains(normalized)) return null;

  return workRegion;
}

Object? _readCareerDescription(Map json, String key) {
  return _firstJsonValue(json, [key, 'enterTpNm']);
}

Object? _readEmploymentName(Map json, String key) {
  return _firstJsonValue(json, [key, 'empTpNm']);
}

Object? _readEducationName(Map json, String key) {
  return _firstJsonValue(json, [key, 'eduNm']);
}

Object? _readSalaryDescription(Map json, String key) {
  return _firstJsonValue(json, [key, 'salTpNm']);
}

Object? _readPostingUrl(Map json, String key) {
  return _firstJsonValue(json, [key, 'dtlRecrContUrl']);
}

Object? _firstJsonValue(Map json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isEmpty) continue;
    if (value != null) return value;
  }
  return null;
}

Object? _nestedJsonValue(Map json, String objectKey, String valueKey) {
  final object = json[objectKey];
  if (object is Map) {
    final value = object[valueKey];
    if (value is String && value.trim().isEmpty) return null;
    return value;
  }
  return null;
}

const Set<String> _workRegionCodes = {
  'SEOUL',
  'BUSAN',
  'DAEGU',
  'INCHEON',
  'GWANGJU',
  'DAEJEON',
  'ULSAN',
  'SEJONG',
  'GYEONGGI',
  'GANGWON',
  'CHUNGBUK',
  'CHUNGNAM',
  'JEONBUK',
  'JEONNAM',
  'GYEONGBUK',
  'GYEONGNAM',
  'JEJU',
  'ETC',
  'UNKNOWN',
};
