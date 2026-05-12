import 'package:flutter/material.dart';

class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color surfaceBorder;
  final Color accent;
  final Color accentDim;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color navActive;
  final Color navInactive;

  const AppColorExtension({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.surfaceBorder,
    required this.accent,
    required this.accentDim,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.navActive,
    required this.navInactive,
  });

  @override
  AppColorExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? surfaceBorder,
    Color? accent,
    Color? accentDim,
    Color? primary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? navActive,
    Color? navInactive,
  }) {
    return AppColorExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      accent: accent ?? this.accent,
      accentDim: accentDim ?? this.accentDim,
      primary: primary ?? this.primary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
    );
  }

  @override
  AppColorExtension lerp(AppColorExtension? other, double t) {
    if (other is! AppColorExtension) return this;
    return AppColorExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceBorder: Color.lerp(surfaceBorder, other.surfaceBorder, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
    );
  }

  static const dark = AppColorExtension(
    background:    Color(0xFF0A1628),
    surface:       Color(0xFF132038),
    surfaceLight:  Color(0xFF1A2D4A),
    surfaceBorder: Color(0xFF1E3A5F),
    accent:        Color(0xFF00D4FF),
    accentDim:     Color(0x2200D4FF),
    primary:       Color(0xFF1565C0),
    textPrimary:   Color(0xFFF0F4F8),
    textSecondary: Color(0xFF8BA7C7),
    textHint:      Color(0xFF4A6280),
    divider:       Color(0xFF1E3A5F),
    navActive:     Color(0xFF00D4FF),
    navInactive:   Color(0xFF4A6280),
  );

  static const light = AppColorExtension(
    background:    Color(0xFFEBE4D5),
    surface:       Color(0xFFF5EEE4),
    surfaceLight:  Color(0xFFFFFFFF),
    surfaceBorder: Color(0xFFD6CABA),
    accent:        Color(0xFFFF803B),
    accentDim:     Color(0x22FF803B),
    primary:       Color(0xFF805C4D),
    textPrimary:   Color(0xFF513C33),
    textSecondary: Color(0xFF805C4D),
    textHint:      Color(0xFFB39B8A),
    divider:       Color(0xFFD6CABA),
    navActive:     Color(0xFFFF803B),
    navInactive:   Color(0xFFB39B8A),
  );
}

extension AppColorsX on BuildContext {
  AppColorExtension get colors =>
      Theme.of(this).extension<AppColorExtension>()!;
}
