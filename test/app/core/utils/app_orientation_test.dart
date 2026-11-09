import 'dart:ui' as ui;

import 'package:duty_it/app/core/utils/app_orientation.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<List<dynamic>> requests;

  setUp(() {
    requests = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemChrome.setPreferredOrientations') {
            requests.add(List<dynamic>.from(call.arguments as List));
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  for (final size in [const Size(2560, 1600), const Size(1600, 2560)]) {
    testWidgets('tablet $size starts without a portrait request', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 2;
      tester.view.physicalSize = size;
      tester.view.display.size = size;
      addTearDown(tester.view.reset);
      addTearDown(tester.view.display.reset);

      await AppOrientation.configureStartup();
      expect(requests, [isEmpty]);

      // Mounting the app must not reintroduce a portrait lock after startup.
      await tester.pumpWidget(
        const MaterialApp(home: DuoLayout(child: SizedBox())),
      );
      expect(requests.every((request) => request.isEmpty), isTrue);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  }

  testWidgets('letterboxed tablet uses its full display before mounting', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.display.size = const Size(2560, 1600);
    addTearDown(tester.view.reset);
    addTearDown(tester.view.display.reset);

    await AppOrientation.configureStartup();
    expect(requests, [isEmpty]);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('narrow foldable can start unlocked before mounting', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 2;
    tester.view.display.size = const Size(1000, 1800);
    tester.view.displayFeatures = [
      const ui.DisplayFeature(
        bounds: Rect.fromLTWH(250, 0, 0, 900),
        type: ui.DisplayFeatureType.fold,
        state: ui.DisplayFeatureState.postureHalfOpened,
      ),
    ];
    addTearDown(tester.view.reset);
    addTearDown(tester.view.display.reset);

    await AppOrientation.configureStartup();
    expect(requests, [isEmpty]);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('folding during initialization applies portrait on first mount', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 2;
    tester.view.display.size = const Size(1800, 2200);
    addTearDown(tester.view.reset);
    addTearDown(tester.view.display.reset);

    await AppOrientation.configureStartup();
    expect(requests, [isEmpty]);

    // Firebase and storage initialization can outlive a posture change.
    tester.view.display.size = const Size(800, 1800);
    await tester.pumpWidget(
      const MaterialApp(home: DuoLayout(child: SizedBox())),
    );
    expect(requests.last, [
      'DeviceOrientation.portraitUp',
      'DeviceOrientation.portraitDown',
    ]);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('$platform phone retains portrait startup', (tester) async {
      tester.view.devicePixelRatio = 2;
      tester.view.display.size = const Size(1800, 800);
      addTearDown(tester.view.reset);
      addTearDown(tester.view.display.reset);

      await AppOrientation.configureStartup();
      expect(requests, [
        ['DeviceOrientation.portraitUp', 'DeviceOrientation.portraitDown'],
      ]);
    }, variant: TargetPlatformVariant.only(platform));
  }
}
