import 'dart:ui' as ui;

import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/app/core/theme/app_theme.dart';
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
    final media = MediaQuery.of(context);
    final enabled =
        image != null &&
        !media.highContrast &&
        !media.accessibleNavigation &&
        !DuoLayoutData.of(context).reduceTransparency;
    const posterColors = AppPalette.dark;
    final ambient = posterColors.copyWith(
      canvas: Colors.transparent,
      surface: posterColors.surface.withAlpha(190),
      subtleSurface: posterColors.subtleSurface.withAlpha(190),
      mutedSurface: posterColors.mutedSurface.withAlpha(210),
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
                // Keep light text readable while loading and on image failure.
                color: enabled ? posterColors.canvas : colors.canvas,
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
                                const ColoredBox(color: Color(0xCC000000)),
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
              // The photo treatment has its own dark appearance in both modes.
              // Dialogs and other routes continue to use the app's system theme.
              ? AppTheme.dark.copyWith(
                  platform: theme.platform,
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
