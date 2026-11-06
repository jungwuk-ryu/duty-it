import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';

/// A bounded glass surface for navigation, shared by iOS and Android.
/// Keep feed cards opaque: only a few bounded controls sample the backdrop.
class DuitGlass extends StatelessWidget {
  const DuitGlass({
    super.key,
    required this.child,
    this.radius = 28,
    this.showShadow = true,
  });
  final Widget child;
  final double radius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final border = BorderRadius.circular(radius);
    final opaque =
        DuoLayoutData.of(context).reduceTransparency ||
        media.highContrast ||
        media.disableAnimations ||
        media.accessibleNavigation;
    final surface = opaque || !ui.ImageFilter.isShaderFilterSupported
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: border,
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: child,
          )
        : LiquidGlass.withOwnLayer(
            shape: LiquidRoundedSuperellipse(borderRadius: radius),
            settings: const LiquidGlassSettings(
              thickness: 14,
              blur: 6,
              glassColor: Color(0xCCFFFFFF),
              refractiveIndex: 1.12,
              chromaticAberration: 0,
              lightIntensity: 0.6,
              saturation: 1.05,
            ),
            child: child,
          );
    if (!showShadow) return surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: border,
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: surface,
    );
  }
}
