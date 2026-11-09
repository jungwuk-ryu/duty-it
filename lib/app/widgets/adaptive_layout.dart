import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:duty_it/app/widgets/duo_layout.dart';

/// Keep forms and reading content usable without stretching across a tablet.
class AdaptiveContent extends StatelessWidget {
  const AdaptiveContent({
    super.key,
    required this.child,
    this.maxWidth = 840,
    this.screenLeft = 0,
    this.avoidFold = true,
  });

  final Widget child;
  final double maxWidth;

  /// Global left edge after the parent's SafeArea or side controls.
  final double screenLeft;
  final bool avoidFold;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      var insets = EdgeInsets.zero;
      // Only split the horizontal reading width here. Vertical obstructions are
      // handled by route safe areas rather than adding screen-height padding to a toolbar.
      for (final fold
          in avoidFold ? DuoLayoutData.of(context).divisions : const <Rect>[]) {
        if (fold.height <= fold.width ||
            fold.left <= screenLeft ||
            fold.right >= screenLeft + constraints.maxWidth) {
          continue;
        }
        final left = fold.left - screenLeft;
        final right = screenLeft + constraints.maxWidth - fold.right;
        insets = left >= right
            ? EdgeInsets.only(
                right: constraints.maxWidth - math.max(0, left - 12),
              )
            : EdgeInsets.only(left: fold.right - screenLeft + 12);
        break;
      }
      return Padding(
        padding: insets,
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      );
    },
  );
}

class AdaptiveLayout extends StatelessWidget {
  static bool useNavigationRail(Size window) =>
      window.width >= 600 && window.height >= 480;

  static bool isWide(BuildContext context, double width) {
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return width >= 840 * (scale > 1 ? scale : 1);
  }

  final Widget phone;
  final Widget tablet;

  const AdaptiveLayout({super.key, required this.phone, required this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        double width = constraints.maxWidth;

        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        if (width < 600 * (textScale > 1 ? textScale : 1)) return phone;
        return tablet;
      },
    );
  }
}
