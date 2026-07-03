import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JobPosting', () {
    test('parses current job posting response fields', () {
      final job = JobPosting.fromJson({
        'id': 4551,
        'wantedAuthNo': 'KF10932606190005',
        'company': {
          'corpNm': '해운누리한의원',
          'corpAddr': '48110 부산광역시 해운대구 세실로 48',
          'busiCont': '의료보건',
        },
        'jobsNm': '간호조무사(307500)',
        'wantedTitle': '[좌동] 치료실 간호조무사 구인',
        'relJobsNm': '간호조무사',
        'jobCont': '원장단 진료 보조',
        'receiptCloseDt': '20260718',
        'empTpNm': '기간의 정함이 있는 근로계약',
        'collectPsncnt': '1',
        'salTpNm': '연봉23,350,156원 이상 ~ 23,350,156원 이하,',
        'enterTpNm': '관계없음',
        'eduNm': '학력무관',
        'certificate': '간호조무사',
        'workRegion': '(48110) 부산광역시 해운대구 세실로 48',
        'nearLine': '2호선 장산 1번출구 10M',
        'workdayWorkhrCont': '주 4일 근무, 평균근무시간 : 32',
        'fourIns': '국민연금 고용보험 산재보험 의료보험',
        'retirepay': '퇴직금',
        'etcWelfare': '기타(비급여 항목 할인)',
        'dtlRecrContUrl': 'https://www.work24.go.kr/example',
        'keywordList': ['간호', '외래'],
        'isBookmarked': false,
        'createdAt': '2026-06-19T21:02:21.544754',
        'updatedAt': '2026-06-19T21:02:21.544758',
      });

      expect(job.companyName, '해운누리한의원');
      expect(job.companyAddress, '48110 부산광역시 해운대구 세실로 48');
      expect(job.title, '[좌동] 치료실 간호조무사 구인');
      expect(job.jobCategory, '간호조무사(307500)');
      expect(job.employmentTypeText, '기간의 정함이 있는 근로계약');
      expect(job.educationText, '학력무관');
      expect(job.salaryText, '연봉23,350,156원 이상 ~ 23,350,156원 이하');
      expect(job.locationText, '(48110) 부산광역시 해운대구 세실로 48');
      expect(job.postingUrl, 'https://www.work24.go.kr/example');
      expect(job.keywordText, '간호, 외래');
      expect(job.welfareTags, containsAll(['퇴직금', '비급여 항목 할인']));
    });

    test('keeps normalized work region enum fallback for list responses', () {
      final job = JobPosting.fromJson({
        'id': 1,
        'title': '간호사 모집',
        'companyName': '테스트병원',
        'workRegion': 'BUSAN',
        'workDistrict': '해운대구',
        'isBookmarked': false,
      });

      expect(job.location, isEmpty);
      expect(job.locationText, '부산 해운대구');
    });

    test('falls back to alias fields when normalized fields are blank', () {
      final job = JobPosting.fromJson({
        'id': 2,
        'title': '',
        'wantedTitle': '요양병원 간호사 모집',
        'companyName': '',
        'company': {'corpNm': '듀잇병원'},
        'jobCategory': '',
        'jobsNm': '간호사(304000)',
        'location': '',
        'workRegion': '(12345) 서울특별시 강남구',
        'isBookmarked': false,
      });

      expect(job.title, '요양병원 간호사 모집');
      expect(job.companyName, '듀잇병원');
      expect(job.jobCategory, '간호사(304000)');
      expect(job.locationText, '(12345) 서울특별시 강남구');
    });

    test('distinguishes ongoing close text from on-hire close text', () {
      final ongoingJob = JobPosting.fromJson({
        'id': 3,
        'receiptCloseDt': '상시채용',
        'isBookmarked': false,
      });
      final onHireJob = JobPosting.fromJson({
        'id': 4,
        'receiptCloseDt': '채용시까지',
        'isBookmarked': false,
      });

      expect(ongoingJob.closeLabel, '상시채용');
      expect(ongoingJob.expiresAtText, '상시채용');
      expect(onHireJob.closeLabel, '채용시 마감');
      expect(onHireJob.expiresAtText, '채용시 마감');
    });
  });
}
