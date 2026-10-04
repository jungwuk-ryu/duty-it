import 'package:duty_it/app/core/enums/job_source_type.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/job_posting_url_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveJobPostingUri', () {
    test('resolves Work24 jobs to the mobile detail URL', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.work24,
        wantedAuthNo: ' K120612606230067 ',
        postingUrl:
            'https://www.work24.go.kr/wk/a/b/1500/empDetailAuthView.do'
            '?wantedAuthNo=K120612606230067'
            '&infoTypeCd=VALIDATION'
            '&infoTypeGroup=tb_workinfoworknet',
      );

      expect(
        resolveJobPostingUri(job).toString(),
        'https://m.work24.go.kr/wk/a/b/1500/empDetailAuthView.do'
        '?wantedAuthNo=K120612606230067'
        '&infoTypeCd=VALIDATION'
        '&infoTypeGroup=tb_workinfoworknet',
      );
    });

    test('resolves Work24 jobs even when the original URL is empty', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.work24,
        wantedAuthNo: 'K120612606230067',
      );

      expect(
        resolveJobPostingUri(job).toString(),
        'https://m.work24.go.kr/wk/a/b/1500/empDetailAuthView.do'
        '?wantedAuthNo=K120612606230067'
        '&infoTypeCd=VALIDATION'
        '&infoTypeGroup=tb_workinfoworknet',
      );
    });

    test('keeps Work24 info type query values from the original URL', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.work24,
        wantedAuthNo: 'DUMMY001',
        postingUrl:
            'https://www.work24.go.kr/wk/a/b/1500/empDetailAuthView.do'
            '?infoTypeCd=PRIVATE'
            '&infoTypeGroup=tb_workinfoscrap',
      );

      expect(
        resolveJobPostingUri(job).toString(),
        'https://m.work24.go.kr/wk/a/b/1500/empDetailAuthView.do'
        '?wantedAuthNo=DUMMY001'
        '&infoTypeCd=PRIVATE'
        '&infoTypeGroup=tb_workinfoscrap',
      );
    });

    test('falls back to the original absolute URL for non-Work24 jobs', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.saramin,
        wantedAuthNo: 'SARAMIN001',
        postingUrl: 'https://www.saramin.co.kr/zf_user/jobs/relay/view',
      );

      expect(
        resolveJobPostingUri(job).toString(),
        'https://www.saramin.co.kr/zf_user/jobs/relay/view',
      );
    });

    test('does not rewrite non-Work24 jobs with Work24-hosted URLs', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.saramin,
        wantedAuthNo: 'SARAMIN001',
        postingUrl: 'https://www.work24.go.kr/relay/saramin',
      );

      expect(
        resolveJobPostingUri(job).toString(),
        'https://www.work24.go.kr/relay/saramin',
      );
    });

    test('rejects non-web absolute URLs', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.unknown,
        postingUrl: 'ftp://example.com/job',
      );

      expect(resolveJobPostingUri(job), isNull);
    });

    test('returns null when no launchable URL is available', () {
      final job = JobPosting(
        id: 1,
        sourceType: JobSourceType.unknown,
        postingUrl: '/relative/path',
      );

      expect(resolveJobPostingUri(job), isNull);
    });
  });
}
