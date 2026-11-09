import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppOrientation {
  static const portrait = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static bool allowsAndroidRotation(
    ui.FlutterView view, {
    bool hasFold = false,
  }) {
    // Use the physical display: window size can shrink with letterboxing,
    // split screen, or the keyboard without changing the device's form factor.
    final display = view.display;
    return hasFold ||
        view.displayFeatures.any(
          (feature) =>
              feature.type == ui.DisplayFeatureType.fold ||
              feature.type == ui.DisplayFeatureType.hinge,
        ) ||
        display.size.shortestSide / display.devicePixelRatio >= 600;
  }

  static Future<void> configureStartup() {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    final allowsRotation =
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        view != null &&
        allowsAndroidRotation(view);
    return SystemChrome.setPreferredOrientations(
      allowsRotation ? const [] : portrait,
    );
  }
}
