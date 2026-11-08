import 'package:duty_it/app/core/constants/app_colors.dart';
import 'package:duty_it/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppTheme {
  static final light = _build(Brightness.light, AppPalette.light);
  static final dark = _build(Brightness.dark, AppPalette.dark);

  static SystemUiOverlayStyle overlayStyle(Brightness brightness) =>
      (brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark)
          .copyWith(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            systemNavigationBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          );

  static ThemeData _build(Brightness brightness, AppPalette colors) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.main,
          brightness: brightness,
        ).copyWith(
          primary: colors.accent,
          onPrimary: brightness == Brightness.dark
              ? const Color(0xFF3D0905)
              : Colors.white,
          primaryContainer: colors.accentSurface,
          onPrimaryContainer: colors.accent,
          surface: colors.canvas,
          surfaceContainerLow: colors.subtleSurface,
          surfaceContainer: colors.mutedSurface,
          surfaceContainerHigh: colors.mutedSurface,
          surfaceContainerHighest: colors.border,
          onSurface: colors.text,
          onSurfaceVariant: colors.muted,
          outline: colors.disabled,
          outlineVariant: colors.border,
        );
    return ThemeData(
      brightness: brightness,
      fontFamily: FontFamily.pretendard,
      colorScheme: scheme,
      extensions: [colors],
      primaryColor: colors.accent,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      cardColor: colors.surface,
      dividerColor: colors.border,
      disabledColor: colors.disabled,
      iconTheme: IconThemeData(color: colors.icon),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.text,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: overlayStyle(brightness),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.surface),
      dialogTheme: DialogThemeData(backgroundColor: colors.surface),
      drawerTheme: DrawerThemeData(backgroundColor: colors.surface),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? colors.mutedSurface
            : AppColors.g07,
        contentTextStyle: TextStyle(
          fontFamily: FontFamily.pretendard,
          color: brightness == Brightness.dark ? colors.text : Colors.white,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.accent),
    );
  }
}
