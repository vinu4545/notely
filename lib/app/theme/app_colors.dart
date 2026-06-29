import 'package:flutter/material.dart';

/// Centralized color system for Notely.
/// Never use Color(...) directly in widgets.
/// Always use AppColors.

class AppColors {
  AppColors._();

  // ======================================================
  // PRIMARY BRAND COLORS
  // ======================================================

  static const Color primaryPink = Color(0xFFFF4D8D);

  static const Color primaryOrange = Color(0xFFFF8A3D);

  static const Color accentPink = Color(0xFFFFD5E5);

  // ======================================================
  // LIGHT THEME
  // ======================================================

  static const Color background = Color(0xFFFFF8F5);

  static const Color surface = Colors.white;

  static const Color card = Color(0xFFFFFFFF);

  // ======================================================
  // DARK THEME
  // ======================================================

  static const Color darkBackground = Color(0xFF0B0B10);

  static const Color darkSurface = Color(0xFF18181D);

  // ======================================================
  // TEXT
  // ======================================================

  static const Color textPrimary = Color(0xFF1C1C1E);

  static const Color textSecondary = Color(0xFF6C6C70);

  static const Color textWhite = Colors.white;

  // ======================================================
  // STATUS
  // ======================================================

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFFFC107);

  static const Color error = Color(0xFFEF4444);

  static const Color info = Color(0xFF3B82F6);

  // ======================================================
  // BORDERS
  // ======================================================

  static const Color border = Color(0xFFE8E8E8);

  static const Color divider = Color(0xFFF1F1F1);
}