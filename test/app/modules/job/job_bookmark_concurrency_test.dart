import 'dart:async';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/app_user.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_view_controller.dart';
import 'package:duty_it/app/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Auth extends AuthService {
  final profile = Completer<AppUser?>();
  int loads = 0;

  @override
  // ignore: must_call_super
  void onInit() {}
  @override
  bool isLoggined() => true;
  @override
  Future<AppUser?> ensureAppUserLoaded() {
    loads++;
    return profile.future;
  }
}

class _Api extends ApiClient {
  final calls = <int>[];
  final responses = <Completer<RequestResult<bool>>>[];

  @override
  void onInit() {}
  @override
  Future<RequestResult<bool>> toggleJobBookmark(int id) {
    calls.add(id);
    final response = Completer<RequestResult<bool>>();
    responses.add(response);
    return response.future;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);

  test(
    'menu and bottom bar cannot toggle the same job twice in flight',
    () async {
      final auth = Get.put<AuthService>(_Auth()) as _Auth;
      final api = Get.put<ApiClient>(_Api()) as _Api;
      final controller = JobViewController();
      final job = const JobPosting(id: 7).obs;
      final other = const JobPosting(id: 8).obs;

      final first = controller.onBookmarkButtonClick(job);
      await controller.onBookmarkButtonClick(job);
      // Another Rx of the same posting must share the guard too.
      await controller.onBookmarkButtonClick(const JobPosting(id: 7).obs);
      final independent = controller.onBookmarkButtonClick(other);
      expect(auth.loads, 2);

      auth.profile.complete(const AppUser(id: 1));
      await Future<void>.delayed(Duration.zero);
      expect(api.calls, [7, 8]);
      await controller.onBookmarkButtonClick(job);
      expect(api.calls, [7, 8]);

      api.responses[0].complete(RequestSuccess(true));
      api.responses[1].complete(RequestSuccess(true));
      await Future.wait([first, independent]);
      expect(job.value.isBookmarked, isTrue);

      final next = controller.onBookmarkButtonClick(job);
      await Future<void>.delayed(Duration.zero);
      expect(api.calls, [7, 8, 7]);
      api.responses[2].complete(RequestSuccess(false));
      await next;
      expect(job.value.isBookmarked, isFalse);
    },
  );
}
