import 'package:duty_it/app/core/enums/job_source_type.dart';
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
      expect(job.mapSearchAddress, '부산 해운대구');
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

    test('decodes html entities in title fields', () {
      final listJob = JobPosting.fromJson({
        'id': 5,
        'title': '&lt;간호사&gt; 채용 &amp; 교육 담당자',
        'isBookmarked': false,
      });
      final detailJob = JobPosting.fromJson({
        'id': 6,
        'title': '',
        'wantedTitle': '&#X5B;서울&#93; 병동 간호사 &quot;상시&quot; 모집',
        'isBookmarked': false,
      });

      expect(listJob.title, '<간호사> 채용 & 교육 담당자');
      expect(detailJob.title, '[서울] 병동 간호사 "상시" 모집');
    });

    test('strips leading postal code from map search address', () {
      final job = JobPosting.fromJson({
        'id': 12,
        'location': '(41771) 대구광역시 서구 국채보상로 170',
        'isBookmarked': false,
      });

      expect(job.locationText, '(41771) 대구광역시 서구 국채보상로 170');
      expect(job.mapSearchAddress, '대구광역시 서구 국채보상로 170');
    });

    test('uses mobile Work24 detail URL for external posting link', () {
      final job = JobPosting.fromJson({
        'id': 7,
        'wantedAuthNo': 'K150012607090001',
        'dtlRecrContUrl':
            'https://www.work24.go.kr/wk/a/b/1570/empDetailView.do?wantedAuthNo=K150012607090001',
        'isBookmarked': false,
      });

      expect(
        job.externalPostingUrl,
        'https://m.work24.go.kr/wk/a/b/1500/empDetailAuthView.do?infoTypeCd=VALIDATION&infoTypeGroup=tb_workinfoworknet&wantedAuthNo=K150012607090001',
      );
    });

    test('extracts Work24 auth number from posting URL fallback', () {
      final job = JobPosting.fromJson({
        'id': 8,
        'wantedAuthNo': '',
        'dtlRecrContUrl':
            'https://www.work24.go.kr/wk/a/b/1570/empDetailView.do?wantedAuthNo=K180022607080038',
        'isBookmarked': false,
      });

      expect(
        job.externalPostingUrl,
        'https://m.work24.go.kr/wk/a/b/1500/empDetailAuthView.do?infoTypeCd=VALIDATION&infoTypeGroup=tb_workinfoworknet&wantedAuthNo=K180022607080038',
      );
    });

    test('does not treat lookalike Work24 host as Work24', () {
      final job = JobPosting(
        id: 9,
        sourceType: JobSourceType.saramin,
        postingUrl:
            'https://notwork24.go.kr/wk/a/b/1570/empDetailView.do?wantedAuthNo=K150012607090001',
      );

      expect(job.externalPostingUrl, job.postingUrl);
    });

    test('blocks unsupported external posting URL schemes', () {
      final job = JobPosting(
        id: 10,
        sourceType: JobSourceType.saramin,
        postingUrl: 'intent://job-detail#Intent;scheme=https;end',
      );

      expect(job.externalPostingUrl, isEmpty);
      expect(job.externalPostingUri, isNull);
    });

    test('blocks web posting URLs without a host', () {
      final job = JobPosting(
        id: 11,
        sourceType: JobSourceType.saramin,
        postingUrl: 'https:example.com/job-detail',
      );

      expect(job.externalPostingUrl, isEmpty);
      expect(job.externalPostingUri, isNull);
    });

    test('keeps non-Work24 external posting URL unchanged', () {
      const url = 'https://www.saramin.co.kr/zf_user/jobs/relay/view?rec_idx=1';
      final job = JobPosting(
        id: 8,
        sourceType: JobSourceType.saramin,
        postingUrl: url,
      );

      expect(job.externalPostingUrl, url);
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
