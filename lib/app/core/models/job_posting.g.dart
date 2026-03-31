// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_posting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobPosting _$JobPostingFromJson(Map<String, dynamic> json) => _JobPosting(
  id: (json['id'] as num).toInt(),
  sourceType:
      $enumDecodeNullable(
        _$JobSourceTypeEnumMap,
        json['sourceType'],
        unknownValue: JobSourceType.unknown,
      ) ??
      JobSourceType.unknown,
  title: json['title'] as String? ?? '?',
  companyName: json['companyName'] as String? ?? '',
  jobCategory: json['jobCategory'] as String? ?? '',
  location: json['location'] as String? ?? '',
  workRegion: $enumDecodeNullable(
    _$WorkRegionEnumMap,
    json['workRegion'],
    unknownValue: WorkRegion.unknown,
  ),
  workDistrict: json['workDistrict'] as String? ?? '',
  employmentType: $enumDecodeNullable(
    _$JobEmploymentTypeEnumMap,
    json['employmentType'],
    unknownValue: JobEmploymentType.unknown,
  ),
  careerDescription: json['careerDescription'] as String? ?? '',
  educationLevel: $enumDecodeNullable(
    _$JobEducationLevelEnumMap,
    json['educationLevel'],
    unknownValue: JobEducationLevel.unknown,
  ),
  salaryDescription: json['salaryDescription'] as String? ?? '',
  salaryType: $enumDecodeNullable(
    _$JobSalaryTypeEnumMap,
    json['salaryType'],
    unknownValue: JobSalaryType.unknown,
  ),
  postingUrl: json['postingUrl'] as String? ?? '',
  postedAt: json['postedAt'] == null
      ? null
      : DateTime.parse(json['postedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  closeType:
      $enumDecodeNullable(
        _$JobCloseTypeEnumMap,
        json['closeType'],
        unknownValue: JobCloseType.unknown,
      ) ??
      JobCloseType.unknown,
  isBookmarked: json['isBookmarked'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$JobPostingToJson(_JobPosting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceType': _$JobSourceTypeEnumMap[instance.sourceType]!,
      'title': instance.title,
      'companyName': instance.companyName,
      'jobCategory': instance.jobCategory,
      'location': instance.location,
      'workRegion': _$WorkRegionEnumMap[instance.workRegion],
      'workDistrict': instance.workDistrict,
      'employmentType': _$JobEmploymentTypeEnumMap[instance.employmentType],
      'careerDescription': instance.careerDescription,
      'educationLevel': _$JobEducationLevelEnumMap[instance.educationLevel],
      'salaryDescription': instance.salaryDescription,
      'salaryType': _$JobSalaryTypeEnumMap[instance.salaryType],
      'postingUrl': instance.postingUrl,
      'postedAt': instance.postedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'closeType': _$JobCloseTypeEnumMap[instance.closeType]!,
      'isBookmarked': instance.isBookmarked,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$JobSourceTypeEnumMap = {
  JobSourceType.saramin: 'SARAMIN',
  JobSourceType.work24: 'WORK24',
  JobSourceType.unknown: 'unknown',
};

const _$WorkRegionEnumMap = {
  WorkRegion.seoul: 'SEOUL',
  WorkRegion.busan: 'BUSAN',
  WorkRegion.daegu: 'DAEGU',
  WorkRegion.incheon: 'INCHEON',
  WorkRegion.gwangju: 'GWANGJU',
  WorkRegion.daejeon: 'DAEJEON',
  WorkRegion.ulsan: 'ULSAN',
  WorkRegion.sejong: 'SEJONG',
  WorkRegion.gyeonggi: 'GYEONGGI',
  WorkRegion.gangwon: 'GANGWON',
  WorkRegion.chungbuk: 'CHUNGBUK',
  WorkRegion.chungnam: 'CHUNGNAM',
  WorkRegion.jeonbuk: 'JEONBUK',
  WorkRegion.jeonnam: 'JEONNAM',
  WorkRegion.gyeongbuk: 'GYEONGBUK',
  WorkRegion.gyeongnam: 'GYEONGNAM',
  WorkRegion.jeju: 'JEJU',
  WorkRegion.etc: 'ETC',
  WorkRegion.unknown: 'unknown',
};

const _$JobEmploymentTypeEnumMap = {
  JobEmploymentType.fullTime: 'FULL_TIME',
  JobEmploymentType.contract: 'CONTRACT',
  JobEmploymentType.partTime: 'PART_TIME',
  JobEmploymentType.dispatch: 'DISPATCH',
  JobEmploymentType.intern: 'INTERN',
  JobEmploymentType.etc: 'ETC',
  JobEmploymentType.unknown: 'unknown',
};

const _$JobEducationLevelEnumMap = {
  JobEducationLevel.none: 'NONE',
  JobEducationLevel.highSchool: 'HIGH_SCHOOL',
  JobEducationLevel.associate: 'ASSOCIATE',
  JobEducationLevel.bachelor: 'BACHELOR',
  JobEducationLevel.master: 'MASTER',
  JobEducationLevel.doctor: 'DOCTOR',
  JobEducationLevel.unknown: 'unknown',
};

const _$JobSalaryTypeEnumMap = {
  JobSalaryType.annual: 'ANNUAL',
  JobSalaryType.monthly: 'MONTHLY',
  JobSalaryType.hourly: 'HOURLY',
  JobSalaryType.unknown: 'unknown',
};

const _$JobCloseTypeEnumMap = {
  JobCloseType.fixed: 'FIXED',
  JobCloseType.onHire: 'ON_HIRE',
  JobCloseType.ongoing: 'ONGOING',
  JobCloseType.unknown: 'unknown',
};
