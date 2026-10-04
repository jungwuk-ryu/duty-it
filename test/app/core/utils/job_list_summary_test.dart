import 'package:duty_it/app/core/utils/job_list_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('job card location uses a short region and district', () {
    expect(JobListSummary.location('(27191) 충청북도 제천시 북부로13길 94'), '충북 제천시');
  });

  test('job card career uses the same wording as the web', () {
    expect(JobListSummary.career('관계없음'), '경력무관');
    expect(JobListSummary.career('경력 (최소2년) 우대'), '경력 2년 이상 우대');
  });

  test('job card salary converts won and collapses a range', () {
    expect(JobListSummary.salary('월급3,250,000원 이상'), '월 325만원 이상');
    expect(
      JobListSummary.salary('월급2,300,000원 이상 ~ 2,800,000원 이하'),
      '월 230~280만원',
    );
  });
}
