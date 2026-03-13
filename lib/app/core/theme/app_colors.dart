import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ── Brand Core ──────────────────────────────────────────────────────
  /// Primary Royal Blue
  static const Color primary = Color(0xFF1E63FF);

  /// Secondary Light Blue
  static const Color secondary = Color(0xFF4DA3FF);

  /// Accent Golden Yellow
  static const Color accent = Color(0xFFFFD700);

  /// Crimson Red – updated to Royal Blue for 2026 theme
  static const Color crimson = Color(0xFF1E63FF);

  // ── Blue Shades ──────────────────────────────────────────────────────
  static const Color blue1 = Color(0xFF1E63FF); // Primary
  static const Color blue2 = Color(0xFF3575FF);
  static const Color blue3 = Color(0xFF4D8AFF);
  static const Color blue4 = Color(0xFF659EFF);
  static const Color blue5 = Color(0xFF7DB2FF);
  static const Color blue6 = Color(0xFF95C6FF);

  // ── Backgrounds ──────────────────────────────────────────────────────
  static const Color background  = Color(0xFFEDF4FF); // BG 2
  static const Color backgroundAlt = Color(0xFFE3EEFF); // BG 1
  static const Color surface    = Color(0xFFFFFFFF);

  // ── Text ────────────────────────────────────────────────────────────
  static const Color mainText   = Color(0xFF0D1B3E);
  static const Color text       = Color(0xFF4A5568);
  static const Color hintText   = Color(0xFF95C6FF);

  // ── Input / Cards ───────────────────────────────────────────────────
  static const Color inputField = Color(0xFFEDF4FF);
  static const Color cardBorder = Color(0xFFD0E4FF);

  // ── Status ──────────────────────────────────────────────────────────
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD700);
  static const Color error   = Color(0xFFFF3B30);
  static const Color info    = Color(0xFF4DA3FF);

  // ── Gradients ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E63FF), Color(0xFF3575FF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E63FF), Color(0xFF4DA3FF)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3EEFF), Color(0xFFEDF4FF)],
  );
}

