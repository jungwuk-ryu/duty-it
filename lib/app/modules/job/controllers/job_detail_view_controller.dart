import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/extensions/job_posting_x.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/core/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final uri = job.externalPostingUri;
    if (uri == null) {
      AppUtils.showSnackBar(
        job.postingUrl.isEmpty ? '채용정보 링크가 없습니다.' : '채용정보 링크가 올바르지 않습니다.',
      );
      return;
    }

    final bool didLaunch;
    try {
      didLaunch = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (_) {
      AppUtils.showSnackBar('채용정보 링크를 열지 못했습니다.');
      return;
    }

    if (!didLaunch) {
      AppUtils.showSnackBar('채용정보 링크를 열지 못했습니다.');
    }
  }

  Future<void> openWorkLocationMap() async {
    final address = job.mapSearchAddress;
    if (address.isEmpty) {
      AppUtils.showSnackBar('근무 예정지 주소가 없습니다.');
      return;
    }

    if (await _launchMapUri(
      _defaultMapUri(address),
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }

    final didOpenFallback = await _launchMapUri(
      _naverMapSearchUri(address),
      mode: LaunchMode.inAppBrowserView,
    );
    if (!didOpenFallback) {
      AppUtils.showSnackBar('지도에서 주소를 열지 못했습니다.');
    }
  }

  Future<bool> _launchMapUri(Uri uri, {required LaunchMode mode}) async {
    try {
      return await launchUrl(uri, mode: mode);
    } catch (_) {
      return false;
    }
  }

  Uri _defaultMapUri(String address) {
    if (kIsWeb) return _naverMapSearchUri(address);

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Uri(
          scheme: 'geo',
          path: '0,0',
          query: 'q=${Uri.encodeComponent(address)}',
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Uri.https('maps.apple.com', '/', {'q': address});
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _naverMapSearchUri(address);
    }
  }

  Uri _naverMapSearchUri(String address) {
    return Uri.https('map.naver.com', '/p/search/$address');
  }
}
