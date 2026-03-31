// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:duty_it/app/core/models/cursor_page_info.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_postings_response.freezed.dart';
part 'job_postings_response.g.dart';

JobPostingsResponse jobPostingsResponseFromJson(String str) =>
    JobPostingsResponse.fromJson(json.decode(str));

String jobPostingsResponseToJson(JobPostingsResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class JobPostingsResponse with _$JobPostingsResponse {
  const factory JobPostingsResponse({
    @JsonKey(name: 'content') required List<JobPosting> jobs,
    required CursorPageInfo pageInfo,
  }) = _JobPostingsResponse;

  factory JobPostingsResponse.fromJson(Map<String, dynamic> json) =>
      _$JobPostingsResponseFromJson(json);
}
