import 'package:duty_it/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Paint navigation insets ourselves so Android's three-button scrim cannot
/// retain the previous appearance after a live system theme change.
class AppSystemUi extends StatelessWidget {
  const AppSystemUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    final android = theme.platform == TargetPlatform.android;
    Widget protection(double width, double height) => IgnorePointer(
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: theme.scaffoldBackgroundColor),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyle(theme.brightness),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          if (android && padding.bottom > 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: protection(double.infinity, padding.bottom),
            ),
          if (android && padding.left > 0)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: protection(padding.left, double.infinity),
            ),
          if (android && padding.right > 0)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: protection(padding.right, double.infinity),
            ),
        ],
      ),
    );
  }
}
