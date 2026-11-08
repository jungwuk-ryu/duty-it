import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

enum DuitGlassStyle { regular, selection, compact }

/// Shared glass material for chrome and the smaller controls over event posters.
class DuitGlass extends StatelessWidget {
  const DuitGlass({
    super.key,
    required this.child,
    this.radius = 28,
    this.showShadow = true,
    this.style = DuitGlassStyle.regular,
  });

  final Widget child;
  final double radius;
  final bool showShadow;
  final DuitGlassStyle style;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final opaque =
        DuoLayoutData.of(context).reduceTransparency ||
        media.highContrast ||
        media.disableAnimations ||
        media.accessibleNavigation;
    final selected = style == DuitGlassStyle.selection;
    final shadows = showShadow
        ? const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ]
        : const <BoxShadow>[];
    if (opaque) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4E5E8) : Colors.white,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0xFFD9D9D9)),
          boxShadow: shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: child,
        ),
      );
    }

    // The app currently uses a light theme, even when the OS uses dark mode.
    final brightness = Theme.of(context).brightness;
    final settings = LiquidGlassSettings.ios27Regular(
      brightness: brightness,
      tintAmount: selected ? .4 : .2,
    );
    final appearance = LiquidGlassAppearance.ios27Regular(
      brightness: brightness,
      tint: selected ? const Color(0x2470747C) : const Color(0x10FFFFFF),
    );
    final shape = LiquidRoundedSuperellipse(borderRadius: radius);

    if (style == DuitGlassStyle.compact) {
      // Repeated poster controls keep the same rim but omit backdrop blur
      // and color transfer, so each card adds no backdrop copy while scrolling.
      return FakeGlass(
        shape: shape,
        settings: const LiquidGlassSettings(frost: 0),
        appearance: const LiquidGlassAppearance(tint: Color(0xE8FFFFFF)),
        shadows: shadows,
        child: child,
      );
    }

    final glass = LiquidGlass.withOwnLayer(
      shape: shape,
      settings: settings,
      appearance: appearance,
      shadows: shadows,
      child: child,
    );
    // A tab's selection refracts its containing bar. Both layers stay inside
    // the bar's bounded capture instead of copying the screen independently.
    return selected ? glass : LiquidGlassCapture(child: glass);
  }
}
