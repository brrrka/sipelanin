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
  // AppBar (header) colors — distinct from body in light mode
  final Color appBarBackground;
  final Color appBarForeground;

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
    required this.appBarBackground,
    required this.appBarForeground,
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
    Color? appBarBackground,
    Color? appBarForeground,
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
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarForeground: appBarForeground ?? this.appBarForeground,
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
      appBarBackground: Color.lerp(appBarBackground, other.appBarBackground, t)!,
      appBarForeground: Color.lerp(appBarForeground, other.appBarForeground, t)!,
    );
  }

  static const dark = AppColorExtension(
    background:       Color(0xFF0A1628),
    surface:          Color(0xFF132038),
    surfaceLight:     Color(0xFF1A2D4A),
    surfaceBorder:    Color(0xFF1E3A5F),
    accent:           Color(0xFF00D4FF),
    accentDim:        Color(0x2200D4FF),
    primary:          Color(0xFF1565C0),
    textPrimary:      Color(0xFFF0F4F8),
    textSecondary:    Color(0xFF8BA7C7),
    textHint:         Color(0xFF4A6280),
    divider:          Color(0xFF1E3A5F),
    navActive:        Color(0xFF00D4FF),
    navInactive:      Color(0xFF4A6280),
    appBarBackground: Color(0xFF0A1628),  // same as background
    appBarForeground: Color(0xFFF0F4F8),  // same as textPrimary
  );

  // Light mode: cream body (#EBE4D5) + dark-brown header (#513C33)
  static const light = AppColorExtension(
    background:       Color(0xFFEBE4D5),  // cream body
    surface:          Color(0xFFEDE3CE),  // slightly warmer card surface
    surfaceLight:     Color(0xFFF5EDE0),  // warm off-white for inputs
    surfaceBorder:    Color(0xFFBF9A72),  // visible warm-brown border
    accent:           Color(0xFFFF803B),  // orange
    accentDim:        Color(0x22FF803B),
    primary:          Color(0xFF805C4D),  // medium brown
    textPrimary:      Color(0xFF513C33),  // dark brown
    textSecondary:    Color(0xFF7D5C4A),  // medium brown
    textHint:         Color(0xFFA88A72),  // warm light brown
    divider:          Color(0xFFC8A880),  // warm tan divider
    navActive:        Color(0xFFFF803B),  // orange on cream nav
    navInactive:      Color(0xFFB39B8A),  // muted brown on cream nav
    appBarBackground: Color(0xFF513C33),  // dark brown header
    appBarForeground: Color(0xFFF5EDE0),  // warm cream text/icons on header
  );
}

extension AppColorsX on BuildContext {
  AppColorExtension get colors =>
      Theme.of(this).extension<AppColorExtension>()!;
}
