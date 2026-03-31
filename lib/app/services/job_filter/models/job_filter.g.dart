// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobFilter _$JobFilterFromJson(Map<String, dynamic> json) => _JobFilter(
  workRegions:
      (json['workRegions'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$WorkRegionEnumMap, e))
          .toSet() ??
      const <WorkRegion>{},
  employmentTypes:
      (json['employmentTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$JobEmploymentTypeEnumMap, e))
          .toSet() ??
      const <JobEmploymentType>{},
);

Map<String, dynamic> _$JobFilterToJson(_JobFilter instance) =>
    <String, dynamic>{
      'workRegions': instance.workRegions
          .map((e) => _$WorkRegionEnumMap[e]!)
          .toList(),
      'employmentTypes': instance.employmentTypes
          .map((e) => _$JobEmploymentTypeEnumMap[e]!)
          .toList(),
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
