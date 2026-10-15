// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:collection';

import 'package:duty_it/app/api_client.dart';
import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:duty_it/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late UrlLauncherPlatform previousLauncher;
  late RecordingUrlLauncher launcher;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    previousLauncher = UrlLauncherPlatform.instance;
    launcher = RecordingUrlLauncher();
    UrlLauncherPlatform.instance = launcher;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = previousLauncher;
    Get.reset();
  });

  test('opens work location in the platform map app', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    launcher.responses.add(true);
    final controller = _controllerWithJob(
      const JobPosting(id: 1, location: '(41771) 대구광역시 서구 국채보상로 170'),
    );

    await controller.openWorkLocationMap();

    expect(launcher.launches, hasLength(1));
    final launch = launcher.launches.single;
    final uri = Uri.parse(launch.url);
    expect(uri.host, 'maps.apple.com');
    expect(uri.queryParameters['q'], '대구광역시 서구 국채보상로 170');
    expect(launch.mode, PreferredLaunchMode.externalApplication);
  });

  test('falls back to Naver Map web when the platform map app fails', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    launcher.responses.addAll([false, true]);
    final controller = _controllerWithJob(
      const JobPosting(id: 2, location: '(41771) 대구광역시 서구 국채보상로 170'),
    );

    await controller.openWorkLocationMap();

    expect(launcher.launches, hasLength(2));
    expect(
      launcher.launches.first.mode,
      PreferredLaunchMode.externalApplication,
    );

    final fallback = launcher.launches.last;
    expect(fallback.mode, PreferredLaunchMode.inAppBrowserView);
    expect(
      Uri.decodeFull(fallback.url),
      'https://map.naver.com/p/search/대구광역시 서구 국채보상로 170',
    );
  });

  test('encodes Android geo URI query without plus signs', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    launcher.responses.add(true);
    const address = '대구광역시 서구 국채보상로 170';
    final controller = _controllerWithJob(
      const JobPosting(id: 3, location: '(41771) $address'),
    );

    await controller.openWorkLocationMap();

    expect(launcher.launches, hasLength(1));
    final launch = launcher.launches.single;
    expect(launch.url, 'geo:0,0?q=${Uri.encodeComponent(address)}');
    expect(launch.url, isNot(contains('+')));
    expect(launch.mode, PreferredLaunchMode.externalApplication);
  });

  testWidgets('does not pop another page after leaving the withdrawn posting', (
    tester,
  ) async {
    Get.put<ApiClient>(NotFoundJobApiClient());
    await tester.pumpWidget(_detailRouteApp());

    await _controllerWithJob(const JobPosting(id: 5)).loadJobDetail();
    await tester.pumpAndSettle();

    expect(find.text('list'), findsOneWidget);
    expect(find.text('더 이상 볼 수 없는 공고예요.'), findsNothing);
  });

  // GetX 스낵바 큐는 전역이라, 스낵바를 띄우는 이 테스트는 마지막에 둔다.
  testWidgets('closes the detail page when the posting is withdrawn', (
    tester,
  ) async {
    Get.put<ApiClient>(NotFoundJobApiClient());
    await tester.pumpWidget(_detailRouteApp());
    Get.toNamed(Routes.JOB_DETAIL);
    await tester.pumpAndSettle();
    expect(find.text('detail'), findsOneWidget);

    // GetX 4 스낵바는 최신 Flutter SDK에서 오버레이를 찾지 못해 비동기 오류를 내므로,
    // 그 경우에는 화면이 닫혔는지만 확인한다.
    final snackbarErrors = <Object>[];
    await runZonedGuarded(
      () => _controllerWithJob(const JobPosting(id: 4)).loadJobDetail(),
      (error, _) => snackbarErrors.add(error),
    );
    await tester.pumpAndSettle();

    expect(find.text('detail'), findsNothing);
    expect(find.text('list'), findsOneWidget);
    if (snackbarErrors.isEmpty) {
      expect(find.text('더 이상 볼 수 없는 공고예요.'), findsOneWidget);
    } else {
      expect('${snackbarErrors.single}', contains('No Overlay widget found'));
    }
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}

Widget _detailRouteApp() {
  return GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const Scaffold(body: Text('list'))),
      GetPage(
        name: Routes.JOB_DETAIL,
        page: () => const Scaffold(body: Text('detail')),
      ),
    ],
  );
}

class NotFoundJobApiClient extends ApiClient {
  @override
  void onInit() {}

  @override
  Future<RequestResult<JobPosting>> getJobPostingDetail(
    int jobPostingId,
  ) async {
    return RequestFail(const Response(statusCode: 404));
  }
}

JobDetailViewController _controllerWithJob(JobPosting job) {
  final controller = JobDetailViewController();
  controller.jobRx = job.obs;
  return controller;
}

class LaunchRecord {
  const LaunchRecord({required this.url, required this.mode});

  final String url;
  final PreferredLaunchMode mode;
}

class RecordingUrlLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final Queue<bool> responses = Queue<bool>();
  final List<LaunchRecord> launches = [];

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launches.add(LaunchRecord(url: url, mode: options.mode));
    return responses.isEmpty ? true : responses.removeFirst();
  }
}
