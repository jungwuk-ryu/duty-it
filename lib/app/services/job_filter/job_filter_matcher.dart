import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';

class JobFilterMatcher {
  const JobFilterMatcher._();

  static bool requiresLocalFiltering(JobFilter filter) {
    return filter.workRegions.isNotEmpty ||
        filter.careerFilters.isNotEmpty ||
        !filter.showClosed;
  }

  static bool matches(JobPosting job, JobFilter filter) {
    if (!filter.showClosed && job.isClosed) return false;
    if (!_matchesRegion(job, filter.workRegions)) return false;
    if (filter.careerFilters.isEmpty) return true;

    return filter.careerFilters.any((careerFilter) {
      return _matchesCareerFilter(job.careerDescription, careerFilter);
    });
  }

  static bool _matchesRegion(JobPosting job, Set<WorkRegion> regions) {
    if (regions.isEmpty) return true;

    final inferredRegion = _inferRegion(job);
    if (inferredRegion == null) return false;

    return regions.contains(inferredRegion);
  }

  static WorkRegion? _inferRegion(JobPosting job) {
    final explicitRegion = job.workRegion;
    if (explicitRegion != null && explicitRegion != WorkRegion.unknown) {
      return explicitRegion;
    }

    return _parseRegion(job.location) ??
        _parseRegion(job.workDistrict) ??
        _parseRegion(job.companyAddress);
  }

  static WorkRegion? _parseRegion(String raw) {
    final address = raw
        .replaceFirst(RegExp(r'^\s*\([^)]*\)\s*'), '')
        .replaceFirst(RegExp(r'^\s*\d{5}\s*'), '')
        .trim();
    if (address.isEmpty) return null;

    for (final entry in _regionAliases.entries) {
      if (entry.value.any(address.startsWith)) {
        return entry.key;
      }
    }

    return null;
  }

  static bool _matchesCareerFilter(
    String careerDescription,
    JobCareerFilter filter,
  ) {
    final text = careerDescription.replaceAll(' ', '');
    if (text.isEmpty) return false;

    switch (filter) {
      case JobCareerFilter.entry:
        return text.contains('신입');
      case JobCareerFilter.noPreference:
        return text.contains('무관') || text.contains('관계없음');
      case JobCareerFilter.oneToThree:
        return _matchesCareerYears(text, 1, 3);
      case JobCareerFilter.threeToFive:
        return _matchesCareerYears(text, 3, 5);
      case JobCareerFilter.fiveToTen:
        return _matchesCareerYears(text, 5, 10);
      case JobCareerFilter.tenPlus:
        return _extractCareerYears(text).any((year) => year >= 10);
    }
  }

  static bool _matchesCareerYears(
    String text,
    int minYear,
    int maxExclusiveYear,
  ) {
    return _extractCareerYears(
      text,
    ).any((year) => year >= minYear && year < maxExclusiveYear);
  }

  static List<int> _extractCareerYears(String text) {
    final matches = RegExp(r'(\d+)\s*년').allMatches(text);
    return matches
        .map((match) => int.tryParse(match.group(1) ?? ''))
        .whereType<int>()
        .toList();
  }
}

const Map<WorkRegion, List<String>> _regionAliases = {
  WorkRegion.seoul: ['서울', '서울특별시'],
  WorkRegion.busan: ['부산', '부산광역시'],
  WorkRegion.daegu: ['대구', '대구광역시'],
  WorkRegion.incheon: ['인천', '인천광역시'],
  WorkRegion.gwangju: ['광주', '광주광역시'],
  WorkRegion.daejeon: ['대전', '대전광역시'],
  WorkRegion.ulsan: ['울산', '울산광역시'],
  WorkRegion.sejong: ['세종', '세종특별자치시'],
  WorkRegion.gyeonggi: ['경기', '경기도'],
  WorkRegion.gangwon: ['강원', '강원도', '강원특별자치도'],
  WorkRegion.chungbuk: ['충북', '충청북도'],
  WorkRegion.chungnam: ['충남', '충청남도'],
  WorkRegion.jeonbuk: ['전북', '전라북도', '전북특별자치도'],
  WorkRegion.jeonnam: ['전남', '전라남도'],
  WorkRegion.gyeongbuk: ['경북', '경상북도'],
  WorkRegion.gyeongnam: ['경남', '경상남도'],
  WorkRegion.jeju: ['제주', '제주특별자치도'],
};
