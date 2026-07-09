// ignore_for_file: depend_on_referenced_packages

import 'dart:collection';

import 'package:duty_it/app/core/models/job_posting.dart';
import 'package:duty_it/app/modules/job/controllers/job_detail_view_controller.dart';
import 'package:flutter/foundation.dart';
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
