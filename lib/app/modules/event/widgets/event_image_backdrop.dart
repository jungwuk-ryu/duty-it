import 'dart:ui' as ui;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/widgets/duo_layout.dart';
import 'package:flutter/material.dart';

/// A fixed, decorative poster wash behind the detail route's existing widgets.
class EventImageBackdrop extends StatelessWidget {
  const EventImageBackdrop({
    super.key,
    required this.image,
    required this.child,
  });

  final ImageProvider? image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final dark = theme.brightness == Brightness.dark;
    final media = MediaQuery.of(context);
    final enabled =
        image != null &&
        !media.highContrast &&
        !media.accessibleNavigation &&
        !DuoLayoutData.of(context).reduceTransparency;
    final wash = dark ? const Color(0xCC000000) : const Color(0xD9FFFFFF);
    final ambient = colors.copyWith(
      canvas: Colors.transparent,
      surface: colors.surface.withAlpha(190),
      subtleSurface: colors.subtleSurface.withAlpha(190),
      mutedSurface: colors.mutedSurface.withAlpha(210),
      muted: dark ? colors.muted : const Color(0xFF5C5A58),
      accent: dark ? colors.accent : const Color(0xFFA92E26),
      link: dark ? colors.link : const Color(0xFF304ABD),
    );

    // Keep this tree stable when the poster loads or accessibility changes;
    // detail loading, scroll position, and in-flight actions retain their state.
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: ColoredBox(
                color: colors.canvas,
                child: enabled
                    ? Image(
                        // The background needs color, not a second full-size decode.
                        image: ResizeImage(
                          image!,
                          width: 256,
                          height: 256,
                          policy: ResizeImagePolicy.fit,
                        ),
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                        frameBuilder: (context, child, frame, synchronous) {
                          if (frame == null) return const SizedBox.shrink();
                          return ClipRect(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageFiltered(
                                  imageFilter: ui.ImageFilter.blur(
                                    sigmaX: 64,
                                    sigmaY: 64,
                                    tileMode: ui.TileMode.clamp,
                                  ),
                                  child: child,
                                ),
                                ColoredBox(color: wash),
                              ],
                            ),
                          );
                        },
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      )
                    : null,
              ),
            ),
          ),
        ),
        Theme(
          data: enabled
              ? theme.copyWith(
                  extensions: [
                    ...theme.extensions.values.where(
                      (value) => value is! AppPalette,
                    ),
                    ambient,
                  ],
                )
              : theme,
          child: child,
        ),
      ],
    );
  }
}
