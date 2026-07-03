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
        _readSourceType(json, 'sourceType'),
        unknownValue: JobSourceType.unknown,
      ) ??
      JobSourceType.work24,
  wantedAuthNo: json['wantedAuthNo'] as String? ?? '',
  isActive: json['isActive'] as bool? ?? true,
  title: _readTitle(json, 'title') as String? ?? '?',
  companyName: _readCompanyName(json, 'companyName') as String? ?? '',
  companyAddress: _readCompanyAddress(json, 'companyAddress') as String? ?? '',
  companyBusiness:
      _readCompanyBusiness(json, 'companyBusiness') as String? ?? '',
  jobCategory: _readJobCategory(json, 'jobCategory') as String? ?? '',
  relJobsNm: json['relJobsNm'] as String? ?? '',
  jobCont: json['jobCont'] as String? ?? '',
  receiptCloseDt: json['receiptCloseDt'] as String? ?? '',
  employmentName: _readEmploymentName(json, 'employmentName') as String? ?? '',
  location: _readLocation(json, 'location') as String? ?? '',
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
  careerDescription:
      _readCareerDescription(json, 'careerDescription') as String? ?? '',
  educationLevel: $enumDecodeNullable(
    _$JobEducationLevelEnumMap,
    json['educationLevel'],
    unknownValue: JobEducationLevel.unknown,
  ),
  educationName: _readEducationName(json, 'educationName') as String? ?? '',
  salaryDescription:
      _readSalaryDescription(json, 'salaryDescription') as String? ?? '',
  salaryType: $enumDecodeNullable(
    _$JobSalaryTypeEnumMap,
    json['salaryType'],
    unknownValue: JobSalaryType.unknown,
  ),
  postingUrl: _readPostingUrl(json, 'postingUrl') as String? ?? '',
  collectPsncnt: json['collectPsncnt'] as String? ?? '',
  forLang: json['forLang'] as String? ?? '',
  major: json['major'] as String? ?? '',
  certificate: json['certificate'] as String? ?? '',
  mltsvcExcHope: json['mltsvcExcHope'] as String? ?? '',
  compAbl: json['compAbl'] as String? ?? '',
  pfCond: json['pfCond'] as String? ?? '',
  etcPfCond: json['etcPfCond'] as String? ?? '',
  selMthd: json['selMthd'] as String? ?? '',
  rcptMthd: json['rcptMthd'] as String? ?? '',
  submitDoc: json['submitDoc'] as String? ?? '',
  etcHopeCont: json['etcHopeCont'] as String? ?? '',
  nearLine: json['nearLine'] as String? ?? '',
  workdayWorkhrCont: json['workdayWorkhrCont'] as String? ?? '',
  fourIns: json['fourIns'] as String? ?? '',
  retirepay: json['retirepay'] as String? ?? '',
  etcWelfare: json['etcWelfare'] as String? ?? '',
  disableCvntl: json['disableCvntl'] as String? ?? '',
  attachFileUrl: json['attachFileUrl'] as String? ?? '',
  corpAttachList:
      (json['corpAttachList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  keywordList:
      (json['keywordList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  empChargerDpt: json['empChargerDpt'] as String? ?? '',
  contactTelno: json['contactTelno'] as String? ?? '',
  chargerFaxNo: json['chargerFaxNo'] as String? ?? '',
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
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$JobPostingToJson(_JobPosting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceType': _$JobSourceTypeEnumMap[instance.sourceType]!,
      'wantedAuthNo': instance.wantedAuthNo,
      'isActive': instance.isActive,
      'title': instance.title,
      'companyName': instance.companyName,
      'companyAddress': instance.companyAddress,
      'companyBusiness': instance.companyBusiness,
      'jobCategory': instance.jobCategory,
      'relJobsNm': instance.relJobsNm,
      'jobCont': instance.jobCont,
      'receiptCloseDt': instance.receiptCloseDt,
      'employmentName': instance.employmentName,
      'location': instance.location,
      'workRegion': _$WorkRegionEnumMap[instance.workRegion],
      'workDistrict': instance.workDistrict,
      'employmentType': _$JobEmploymentTypeEnumMap[instance.employmentType],
      'careerDescription': instance.careerDescription,
      'educationLevel': _$JobEducationLevelEnumMap[instance.educationLevel],
      'educationName': instance.educationName,
      'salaryDescription': instance.salaryDescription,
      'salaryType': _$JobSalaryTypeEnumMap[instance.salaryType],
      'postingUrl': instance.postingUrl,
      'collectPsncnt': instance.collectPsncnt,
      'forLang': instance.forLang,
      'major': instance.major,
      'certificate': instance.certificate,
      'mltsvcExcHope': instance.mltsvcExcHope,
      'compAbl': instance.compAbl,
      'pfCond': instance.pfCond,
      'etcPfCond': instance.etcPfCond,
      'selMthd': instance.selMthd,
      'rcptMthd': instance.rcptMthd,
      'submitDoc': instance.submitDoc,
      'etcHopeCont': instance.etcHopeCont,
      'nearLine': instance.nearLine,
      'workdayWorkhrCont': instance.workdayWorkhrCont,
      'fourIns': instance.fourIns,
      'retirepay': instance.retirepay,
      'etcWelfare': instance.etcWelfare,
      'disableCvntl': instance.disableCvntl,
      'attachFileUrl': instance.attachFileUrl,
      'corpAttachList': instance.corpAttachList,
      'keywordList': instance.keywordList,
      'empChargerDpt': instance.empChargerDpt,
      'contactTelno': instance.contactTelno,
      'chargerFaxNo': instance.chargerFaxNo,
      'postedAt': instance.postedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'closeType': _$JobCloseTypeEnumMap[instance.closeType]!,
      'isBookmarked': instance.isBookmarked,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
