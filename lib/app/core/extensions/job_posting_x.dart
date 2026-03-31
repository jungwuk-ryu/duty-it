import 'package:duty_it/app/core/enums/job_close_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:flutter/material.dart';

extension JobPostingX on JobPosting {
  String get locationText {
    if (location.isNotEmpty) return location;

    final region = workRegion?.displayName ?? '';
    if (region.isEmpty) return workDistrict;
    if (workDistrict.isEmpty) return region;

    return '$region $workDistrict';
  }

  String get closeLabel {
    switch (closeType) {
      case JobCloseType.onHire:
        return '채용시 마감';
      case JobCloseType.ongoing:
        return '상시채용';
      case JobCloseType.fixed:
      case JobCloseType.unknown:
        final targetDate = expiresAt;
        if (targetDate == null) {
          return '상시채용';
        }

        final today = DateUtils.dateOnly(DateTime.now());
        final target = DateUtils.dateOnly(targetDate);
        final diff = target.difference(today).inDays;
        if (diff < 0) {
          return '마감';
        }

        return 'D - ${diff.toString().padLeft(2, '0')}';
    }
  }

  String? get careerText {
    if (careerDescription.isEmpty) return null;
    return careerDescription;
  }

  String? get educationText {
    final text = educationLevel?.displayName ?? '';
    return text.isEmpty ? null : text;
  }

  String? get employmentTypeText {
    final text = employmentType?.displayName ?? '';
    return text.isEmpty ? null : text;
  }

  String? get sourceText {
    final text = sourceType.displayName;
    return text.isEmpty ? null : text;
  }

  String? get postedAtText {
    final date = postedAt;
    if (date == null) return null;
    return _formatDotDate(date);
  }

  String? get expiresAtText {
    switch (closeType) {
      case JobCloseType.onHire:
        return '채용시 마감';
      case JobCloseType.ongoing:
        return '상시채용';
      case JobCloseType.fixed:
      case JobCloseType.unknown:
        final date = expiresAt;
        if (date == null) return null;
        return _formatDotDate(date);
    }
  }

  String? get jobCategoryText {
    if (jobCategory.isEmpty) return null;
    return jobCategory;
  }

  String? get salaryText {
    if (salaryDescription.isEmpty) return null;
    return salaryDescription;
  }

  static String _formatDotDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }
}
