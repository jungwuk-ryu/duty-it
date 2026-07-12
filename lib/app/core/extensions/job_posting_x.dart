import 'package:duty_it/app/core/enums/job_close_type.dart';
import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:flutter/material.dart';

extension JobPostingX on JobPosting {
  bool get isClosed {
    if (!isActive) return true;

    final receiptCloseDate = _receiptCloseDateText;
    if (receiptCloseDate != null) {
      if (_isOngoingText(receiptCloseDate) || _isOnHireText(receiptCloseDate)) {
        return false;
      }

      final targetDate = _parseReceiptCloseDate(receiptCloseDate);
      if (targetDate == null) return false;

      final today = DateUtils.dateOnly(DateTime.now());
      final target = DateUtils.dateOnly(targetDate);
      return target.isBefore(today);
    }

    switch (closeType) {
      case JobCloseType.onHire:
      case JobCloseType.ongoing:
        return false;
      case JobCloseType.fixed:
      case JobCloseType.unknown:
        final targetDate = expiresAt;
        if (targetDate == null) return false;

        final today = DateUtils.dateOnly(DateTime.now());
        final target = DateUtils.dateOnly(targetDate);
        return target.isBefore(today);
    }
  }

  String get locationText {
    final rawLocation = _cleanInline(location);
    if (rawLocation != null) return rawLocation;

    final region = workRegion?.displayName ?? '';
    if (region.isEmpty) return workDistrict;
    if (workDistrict.isEmpty) return region;

    return '$region $workDistrict';
  }

  String get mapSearchAddress {
    final address = _stripLeadingPostalCode(locationText);
    if (address.isEmpty) return '';
    return address;
  }

  String get closeLabel {
    final receiptCloseDate = _receiptCloseDateText;
    if (receiptCloseDate != null) {
      if (_isOngoingText(receiptCloseDate)) {
        return '상시채용';
      }

      if (_isOnHireText(receiptCloseDate)) {
        return '채용시 마감';
      }

      final targetDate = _parseReceiptCloseDate(receiptCloseDate);
      if (targetDate == null) {
        return receiptCloseDate;
      }

      final today = DateUtils.dateOnly(DateTime.now());
      final target = DateUtils.dateOnly(targetDate);
      final diff = target.difference(today).inDays;
      if (diff < 0) {
        return '마감';
      }

      return 'D - ${diff.toString().padLeft(2, '0')}';
    }

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
    return _cleanInline(careerDescription);
  }

  String? get educationText {
    return _cleanInline(educationName) ??
        _cleanInline(educationLevel?.displayName ?? '');
  }

  String? get employmentTypeText {
    return _cleanInline(employmentName) ??
        _cleanInline(employmentType?.displayName ?? '');
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
    final receiptCloseDate = _receiptCloseDateText;
    if (receiptCloseDate != null) {
      if (_isOngoingText(receiptCloseDate)) {
        return '상시채용';
      }

      if (_isOnHireText(receiptCloseDate)) {
        return '채용시 마감';
      }

      final parsedDate = _parseReceiptCloseDate(receiptCloseDate);
      return parsedDate == null ? receiptCloseDate : _formatDotDate(parsedDate);
    }

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
    return _cleanInline(jobCategory);
  }

  String? get salaryText {
    return _cleanInline(salaryDescription.replaceFirst(RegExp(r',\s*$'), ''));
  }

  String? get wantedAuthNoText => _cleanInline(wantedAuthNo);

  String get externalPostingUrl => externalPostingUri?.toString() ?? '';

  Uri? get externalPostingUri {
    final work24Uri = _work24MobilePostingUri;
    if (work24Uri != null) return work24Uri;

    final uri = Uri.tryParse(postingUrl);
    if (uri == null || !_isHttpUri(uri)) return null;

    return uri;
  }

  String? get recruitmentCountText {
    final value = _cleanInline(collectPsncnt);
    if (value == null) return null;
    if (RegExp(r'^\d+$').hasMatch(value)) return '$value명';
    return value;
  }

  String? get relatedJobText => _cleanInline(relJobsNm);

  String? get jobContentText => _cleanMultiline(jobCont);

  String? get keywordText {
    final keywords = keywordList
        .map(_cleanInline)
        .whereType<String>()
        .where((keyword) => keyword.isNotEmpty)
        .toList();
    if (keywords.isNotEmpty) return keywords.join(', ');
    return relatedJobText;
  }

  String? get majorText => _cleanInline(major);

  String? get foreignLanguageText => _cleanInline(forLang);

  String? get certificateText => _cleanInline(certificate);

  String? get militaryServiceText => _cleanInline(mltsvcExcHope);

  String? get computerAbilityText => _cleanInline(compAbl);

  String? get preferredConditionText => _cleanInline(pfCond);

  String? get etcPreferredConditionText => _cleanMultiline(etcPfCond);

  String? get selectionMethodText => _cleanInline(selMthd);

  String? get receiptMethodText => _cleanInline(rcptMthd);

  String? get submitDocumentText => _cleanInline(submitDoc);

  String? get etcHopeText => _cleanMultiline(etcHopeCont);

  String? get nearLineText => _cleanInline(nearLine);

  String? get workTimeText => _cleanMultiline(workdayWorkhrCont);

  String? get workTypeText {
    final text = workTimeText;
    if (text == null) return null;
    final match = RegExp(r'주\s*\d+\s*일\s*근무').firstMatch(text);
    return match?.group(0)?.replaceAll(RegExp(r'\s+'), ' ');
  }

  String? get fourInsText => _cleanInline(fourIns);

  String? get retirePayText => _cleanInline(retirepay);

  String? get etcWelfareText => _cleanMultiline(etcWelfare);

  String? get disabilityConvenienceText => _cleanInline(disableCvntl);

  String? get companyAddressText => _cleanInline(companyAddress);

  String? get companyBusinessText => _cleanInline(companyBusiness);

  String? get chargerDepartmentText => _cleanInline(empChargerDpt);

  String? get contactTelnoText => _cleanInline(contactTelno);

  String? get chargerFaxNoText => _cleanInline(chargerFaxNo);

  String? get attachFileUrlText => _cleanInline(attachFileUrl);

  List<String> get welfareTags {
    final tags = <String>[];
    for (final value in [
      retirePayText,
      etcWelfareText,
      disabilityConvenienceText,
    ]) {
      if (value == null || _isEmptyInformation(value)) continue;
      tags.addAll(_splitTagText(value));
    }

    return tags.toSet().toList();
  }

  String? get _receiptCloseDateText => _cleanInline(receiptCloseDt);

  Uri? get _work24MobilePostingUri {
    final authNo = wantedAuthNoText ?? _wantedAuthNoFromPostingUrl;
    if (authNo == null) return null;

    final uri = Uri.tryParse(postingUrl);
    final host = uri?.host.toLowerCase() ?? '';
    if (sourceType != JobSourceType.work24 && !_isWork24Host(host)) {
      return null;
    }

    return Uri.https('m.work24.go.kr', '/wk/a/b/1500/empDetailAuthView.do', {
      'infoTypeCd': 'VALIDATION',
      'infoTypeGroup': 'tb_workinfoworknet',
      'wantedAuthNo': authNo,
    });
  }

  String? get _wantedAuthNoFromPostingUrl {
    final uri = Uri.tryParse(postingUrl);
    if (uri == null || !_isWork24Host(uri.host)) {
      return null;
    }

    return _cleanInline(uri.queryParameters['wantedAuthNo']);
  }

  static bool _isHttpUri(Uri uri) {
    return (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.hasAuthority &&
        uri.host.isNotEmpty;
  }

  static bool _isWork24Host(String host) {
    final normalized = host.toLowerCase();
    return normalized == 'work24.go.kr' || normalized.endsWith('.work24.go.kr');
  }

  static String _stripLeadingPostalCode(String value) {
    return value.replaceFirst(RegExp(r'^\(\s*\d{5}\s*\)\s*'), '').trim();
  }

  static bool _isOnHireText(String value) {
    return value.contains('채용시');
  }

  static bool _isOngoingText(String value) {
    return value.contains('상시');
  }

  static String _formatDotDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }

  static DateTime? _parseReceiptCloseDate(String value) {
    final compact = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (compact.length != 8) return null;

    final year = int.tryParse(compact.substring(0, 4));
    final month = int.tryParse(compact.substring(4, 6));
    final day = int.tryParse(compact.substring(6, 8));
    if (year == null || month == null || day == null) return null;

    return DateTime(year, month, day);
  }

  static String? _cleanInline(String? value) {
    final cleaned = value
        ?.replaceAll('\r', ' ')
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned == null || cleaned.isEmpty || _isEmptyInformation(cleaned)) {
      return null;
    }

    return cleaned;
  }

  static String? _cleanMultiline(String? value) {
    final cleaned = value
        ?.replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .join('\n');
    if (cleaned == null || cleaned.isEmpty || _isEmptyInformation(cleaned)) {
      return null;
    }

    return cleaned;
  }

  static bool _isEmptyInformation(String value) {
    final normalized = value.replaceAll(RegExp(r'[\s,()/-]'), '');
    return normalized.isEmpty || normalized == '없음' || normalized == '해당없음';
  }

  static List<String> _splitTagText(String value) {
    final normalized = value
        .replaceAll('기타(', '')
        .replaceAll(')', '')
        .replaceAll('/', ',')
        .replaceAll('\n', ',');
    return normalized
        .split(',')
        .map(_cleanInline)
        .whereType<String>()
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
