// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_postings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobPostingsResponse _$JobPostingsResponseFromJson(Map<String, dynamic> json) =>
    _JobPostingsResponse(
      jobs: (json['content'] as List<dynamic>)
          .map((e) => JobPosting.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: CursorPageInfo.fromJson(
        json['pageInfo'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$JobPostingsResponseToJson(
  _JobPostingsResponse instance,
) => <String, dynamic>{
  'content': instance.jobs.map((e) => e.toJson()).toList(),
  'pageInfo': instance.pageInfo.toJson(),
};
