import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF242323);
  static const Color main = Color(0xFFC63C33);
  static const Color red = Color(0xFFBB0000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cal1 = Color(0xFFE7E7E7);
  static const Color cal2 = Color(0xFFFFE7E7);
  static const Color cal3 = Color(0xFFE1F0FF);
  static const Color bg = Color(0x66333333);
  static const Color bgCard = Color(0xCC333333);
  static const Color canvas = white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color g01 = Color(0xFFF8F9FA);
  static const Color g02 = Color(0xFFF3F4F6);
  static const Color g03 = Color(0xFFE5E7EB);
  static const Color g04 = Color(0xFF9CA3AF);
  static const Color g05 = Color(0xFF74716F);
  static const Color g06 = Color(0xFF626C7A);
  static const Color g07 = Color(0xFF4B5563);
  static const Color linkBlue = Color(0xFF395ADD);
  static const Color sub = Color(0xFFFCF5F2);
}

/// Semantic colors shared by app screens and glass controls.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.surface,
    required this.text,
    required this.secondaryText,
    required this.muted,
    required this.icon,
    required this.disabled,
    required this.subtleSurface,
    required this.mutedSurface,
    required this.border,
    required this.accent,
    required this.accentSurface,
    required this.link,
    required this.calendarNeutral,
    required this.calendarPink,
    required this.calendarBlue,
  });

  final Color canvas;
  final Color surface;
  final Color text;
  final Color secondaryText;
  final Color muted;
  final Color icon;
  final Color disabled;
  final Color subtleSurface;
  final Color mutedSurface;
  final Color border;
  final Color accent;
  final Color accentSurface;
  final Color link;
  final Color calendarNeutral;
  final Color calendarPink;
  final Color calendarBlue;

  static const light = AppPalette(
    canvas: AppColors.white,
    surface: AppColors.white,
    text: AppColors.black,
    secondaryText: AppColors.g07,
    muted: AppColors.g05,
    icon: AppColors.g06,
    disabled: AppColors.g04,
    subtleSurface: AppColors.g01,
    mutedSurface: AppColors.g02,
    border: AppColors.border,
    accent: AppColors.main,
    accentSurface: AppColors.sub,
    link: AppColors.linkBlue,
    calendarNeutral: AppColors.cal1,
    calendarPink: AppColors.cal2,
    calendarBlue: AppColors.cal3,
  );

  static const dark = AppPalette(
    canvas: Color(0xFF121214),
    surface: Color(0xFF1C1C1E),
    text: Color(0xFFF3F4F6),
    secondaryText: Color(0xFFC3C8D2),
    muted: Color(0xFFB5B1AE),
    icon: Color(0xFFB6BFCD),
    disabled: Color(0xFF8B929F),
    subtleSurface: Color(0xFF1C1C1E),
    mutedSurface: Color(0xFF27272B),
    border: Color(0xFF3D3F46),
    accent: Color(0xFFFF9286),
    accentSurface: Color(0xFF392320),
    link: Color(0xFFA5B5FF),
    calendarNeutral: Color(0xFF303238),
    calendarPink: Color(0xFF482C32),
    calendarBlue: Color(0xFF243A4C),
  );

  /// Calendar models keep their category color; resolve it when rendering.
  Color calendarColor(Color color) => switch (color) {
    AppColors.cal1 => calendarNeutral,
    AppColors.cal2 => calendarPink,
    AppColors.cal3 => calendarBlue,
    _ => color,
  };

  @override
  AppPalette copyWith({
    Color? canvas,
    Color? surface,
    Color? text,
    Color? secondaryText,
    Color? muted,
    Color? icon,
    Color? disabled,
    Color? subtleSurface,
    Color? mutedSurface,
    Color? border,
    Color? accent,
    Color? accentSurface,
    Color? link,
    Color? calendarNeutral,
    Color? calendarPink,
    Color? calendarBlue,
  }) => AppPalette(
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    text: text ?? this.text,
    secondaryText: secondaryText ?? this.secondaryText,
    muted: muted ?? this.muted,
    icon: icon ?? this.icon,
    disabled: disabled ?? this.disabled,
    subtleSurface: subtleSurface ?? this.subtleSurface,
    mutedSurface: mutedSurface ?? this.mutedSurface,
    border: border ?? this.border,
    accent: accent ?? this.accent,
    accentSurface: accentSurface ?? this.accentSurface,
    link: link ?? this.link,
    calendarNeutral: calendarNeutral ?? this.calendarNeutral,
    calendarPink: calendarPink ?? this.calendarPink,
    calendarBlue: calendarBlue ?? this.calendarBlue,
  );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      text: Color.lerp(text, other.text, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
      mutedSurface: Color.lerp(mutedSurface, other.mutedSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSurface: Color.lerp(accentSurface, other.accentSurface, t)!,
      link: Color.lerp(link, other.link, t)!,
      calendarNeutral: Color.lerp(calendarNeutral, other.calendarNeutral, t)!,
      calendarPink: Color.lerp(calendarPink, other.calendarPink, t)!,
      calendarBlue: Color.lerp(calendarBlue, other.calendarBlue, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get colors {
    final theme = Theme.of(this);
    return theme.extension<AppPalette>() ??
        (theme.brightness == Brightness.dark
            ? AppPalette.dark
            : AppPalette.light);
  }
}
