import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──
  static const Color background    = Color(0xFF0A1628); // deep navy
  static const Color surface       = Color(0xFF132038); // card navy
  static const Color surfaceLight  = Color(0xFF1A2D4A); // nested card
  static const Color surfaceBorder = Color(0xFF1E3A5F); // subtle border

  // ── Accent ──
  static const Color cyan          = Color(0xFF00D4FF);
  static const Color cyanDim       = Color(0x2200D4FF); // 13% opacity

  // ── Brand / Primary button ──
  static const Color primary       = Color(0xFF1565C0);
  static const Color primaryLight  = Color(0xFF1976D2);

  // ── Status ──
  static const Color safe          = Color(0xFF00D68F);
  static const Color safeDim       = Color(0x2200D68F); // 13% opacity background
  static const Color danger        = Color(0xFFFF3D71);
  static const Color dangerDim     = Color(0x22FF3D71);
  static const Color standby       = Color(0xFFFFAA00);
  static const Color standbyDim    = Color(0x22FFAA00);

  // ── Text ──
  static const Color textPrimary   = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8BA7C7);
  static const Color textHint      = Color(0xFF4A6280);

  // ── Misc ──
  static const Color divider       = Color(0xFF1E3A5F);
  static const Color navActive     = Color(0xFF00D4FF);
  static const Color navInactive   = Color(0xFF4A6280);
}
