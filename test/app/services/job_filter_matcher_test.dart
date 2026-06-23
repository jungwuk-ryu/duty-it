import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/services/job_filter/job_filter_matcher.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JobFilterMatcher', () {
    test('matches Work24 address strings that start with postal code', () {
      final job = JobPosting.fromJson({
        'id': 1,
        'workRegion': '(37560)  경상북도 포항시 북구 흥해읍 선린대길 30',
      });

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(workRegions: {WorkRegion.gyeongbuk}),
        ),
        isTrue,
      );
      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(workRegions: {WorkRegion.seoul}),
        ),
        isFalse,
      );
    });

    test('matches long-form metropolitan city names', () {
      final job = JobPosting.fromJson({
        'id': 2,
        'workRegion': '(07516) 서울특별시 강서구 양천로 31',
      });

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(workRegions: {WorkRegion.seoul}),
        ),
        isTrue,
      );
    });

    test('uses normalized region enums when the server sends them', () {
      final job = JobPosting.fromJson({
        'id': 3,
        'workRegion': 'BUSAN',
        'workDistrict': '해운대구',
      });

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(workRegions: {WorkRegion.busan}),
        ),
        isTrue,
      );
    });

    test('keeps existing career filtering behavior', () {
      final job = JobPosting.fromJson({'id': 4, 'enterTpNm': '경력 (최소5년) 필수'});

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(careerFilters: {JobCareerFilter.fiveToTen}),
        ),
        isTrue,
      );
      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(careerFilters: {JobCareerFilter.oneToThree}),
        ),
        isFalse,
      );
    });

    test('matches Work24 full-time employment descriptions', () {
      final job = JobPosting.fromJson({
        'id': 5,
        'empTpNm': '기간의 정함이 없는 근로계약/ 파견근로 비희망/ 대체인력채용 비희망',
      });

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(employmentTypes: {JobEmploymentType.fullTime}),
        ),
        isTrue,
      );
      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(employmentTypes: {JobEmploymentType.contract}),
        ),
        isFalse,
      );
    });

    test('matches Work24 contract employment descriptions', () {
      final job = JobPosting.fromJson({
        'id': 6,
        'empTpNm': '기간의 정함이 있는 근로계약12 개월/ 계약기간 만료 후 상용직전환검토',
      });

      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(employmentTypes: {JobEmploymentType.contract}),
        ),
        isTrue,
      );
      expect(
        JobFilterMatcher.matches(
          job,
          const JobFilter(employmentTypes: {JobEmploymentType.fullTime}),
        ),
        isFalse,
      );
    });
  });
}
