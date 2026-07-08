import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class JobDetailViewController extends GetxController {
  final RxBool isLoading = false.obs;

  late final Rx<JobPosting> jobRx;
  JobPosting get job => jobRx.value;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments is! Map || arguments['jobRx'] is! Rx<JobPosting>) {
      AppUtils.showSnackBar('채용 정보를 불러오지 못했습니다.');
      Get.back();
      return;
    }

    jobRx = arguments['jobRx'] as Rx<JobPosting>;

    FirebaseAnalytics.instance.logSelectContent(
      contentType: 'job',
      itemId: job.id.toString(),
    );

    loadJobDetail();
  }

  Future<void> loadJobDetail() async {
    isLoading.value = true;
    try {
      final result = await Get.find<ApiClient>().getJobPostingDetail(job.id);
      if (result is RequestSuccess<JobPosting>) {
        jobRx.value = result.data;
      } else if (result is RequestFail && kDebugMode) {
        AppUtils.showSnackBar(
          result.serverFail?.message ?? '채용 정보를 불러오지 못했습니다.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openPostingUrl() async {
    final url = job.postingUrl;
    if (url.isEmpty) {
      AppUtils.showSnackBar('채용정보 링크가 없습니다.');
      return;
    }

    final didLaunch = await launchUrlString(url);
    if (!didLaunch) {
      AppUtils.showSnackBar('채용정보 링크를 열지 못했습니다.');
    }
  }
}
