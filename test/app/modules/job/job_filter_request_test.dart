import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/enums/job_employment_type.dart';
import 'package:duty_it/app/core/enums/work_region.dart';
import 'package:duty_it/app/core/models/cursor_page_info.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/models/job_postings_response.dart';
import 'package:duty_it/app/modules/bookmark/controllers/bookmark_view_controller.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:duty_it/app/services/job_filter/job_filter_service.dart';
import 'package:duty_it/app/services/job_filter/models/job_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class RecordingJobApiClient extends ApiClient {
  final List<JobPostingsCall> calls = [];

  @override
  void onInit() {}

  @override
  Future<RequestResult<JobPostingsResponse>> getJobPostings({
    String? cursor,
    required bool bookmarked,
    int size = 10,
    String field = 'CREATED_AT',
    required List<WorkRegion> workRegions,
    required List<JobEmploymentType> employmentTypes,
    String? searchKeyword,
  }) async {
    calls.add(
      JobPostingsCall(
        cursor: cursor,
        bookmarked: bookmarked,
        size: size,
        field: field,
        workRegions: List<WorkRegion>.of(workRegions),
        employmentTypes: List<JobEmploymentType>.of(employmentTypes),
        searchKeyword: searchKeyword,
      ),
    );

    return RequestSuccess(
      const JobPostingsResponse(
        jobs: <JobPosting>[],
        pageInfo: CursorPageInfo(hasNext: false, nextCursor: null, pageSize: 0),
      ),
    );
  }
}

class JobPostingsCall {
  const JobPostingsCall({
    required this.cursor,
    required this.bookmarked,
    required this.size,
    required this.field,
    required this.workRegions,
    required this.employmentTypes,
    required this.searchKeyword,
  });

  final String? cursor;
  final bool bookmarked;
  final int size;
  final String field;
  final List<WorkRegion> workRegions;
  final List<JobEmploymentType> employmentTypes;
  final String? searchKeyword;
}

class TestJobFilterService extends JobFilterService {
  // The storage-backed production lifecycle is intentionally bypassed here.
  @override
  // ignore: must_call_super
  void onInit() {}
}

class LoggedInAuthService extends AuthService {
  // The Firebase/social-login production lifecycle is intentionally bypassed here.
  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  bool isLoggined() => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  test(
    'job page sends server-backed filters with the normal page size',
    () async {
      final apiClient = RecordingJobApiClient();
      final filterService = TestJobFilterService();
      Get.put<ApiClient>(apiClient);
      Get.put<JobFilterService>(filterService);
      filterService.updateFilter(
        const JobFilter(
          workRegions: <WorkRegion>{WorkRegion.seoul, WorkRegion.gyeongbuk},
          employmentTypes: <JobEmploymentType>{JobEmploymentType.fullTime},
        ),
      );

      final controller = JobViewController();
      addTearDown(controller.onClose);

      await controller.fetchNextPage(clearPage: true);

      expect(apiClient.calls, hasLength(1));
      final call = apiClient.calls.single;
      expect(call.bookmarked, isFalse);
      expect(call.size, 10);
      expect(
        call.workRegions,
        containsAll(<WorkRegion>[WorkRegion.seoul, WorkRegion.gyeongbuk]),
      );
      expect(call.employmentTypes, <JobEmploymentType>[
        JobEmploymentType.fullTime,
      ]);
    },
  );

  test(
    'job page keeps server filters when local filters require a large page',
    () async {
      final apiClient = RecordingJobApiClient();
      final filterService = TestJobFilterService();
      Get.put<ApiClient>(apiClient);
      Get.put<JobFilterService>(filterService);
      filterService.updateFilter(
        const JobFilter(
          careerFilters: <JobCareerFilter>{JobCareerFilter.noPreference},
          workRegions: <WorkRegion>{WorkRegion.gyeonggi},
          employmentTypes: <JobEmploymentType>{JobEmploymentType.contract},
        ),
      );

      final controller = JobViewController();
      addTearDown(controller.onClose);

      await controller.fetchNextPage(clearPage: true);

      expect(apiClient.calls, hasLength(1));
      final call = apiClient.calls.single;
      expect(call.bookmarked, isFalse);
      expect(call.size, 100);
      expect(call.workRegions, <WorkRegion>[WorkRegion.gyeonggi]);
      expect(call.employmentTypes, <JobEmploymentType>[
        JobEmploymentType.contract,
      ]);
    },
  );

  test(
    'bookmark page sends job filters to the bookmarked job endpoint',
    () async {
      final apiClient = RecordingJobApiClient();
      final filterService = TestJobFilterService();
      Get.put<ApiClient>(apiClient);
      Get.put<JobFilterService>(filterService);
      Get.put<AuthService>(LoggedInAuthService());
      filterService.updateFilter(
        const JobFilter(
          workRegions: <WorkRegion>{WorkRegion.incheon},
          employmentTypes: <JobEmploymentType>{JobEmploymentType.fullTime},
        ),
      );

      final controller = BookmarkViewController();
      addTearDown(controller.onClose);

      await controller.fetchNextJobPage(clearPage: true);

      expect(apiClient.calls, hasLength(1));
      final call = apiClient.calls.single;
      expect(call.bookmarked, isTrue);
      expect(call.size, 10);
      expect(call.workRegions, <WorkRegion>[WorkRegion.incheon]);
      expect(call.employmentTypes, <JobEmploymentType>[
        JobEmploymentType.fullTime,
      ]);
    },
  );
}
