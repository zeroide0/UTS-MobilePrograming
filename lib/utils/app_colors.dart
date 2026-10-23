import 'package:flutter/material.dart';

class AppColors {
  // Background Gradients
  static const Color bgDarkPrimary = Color(0xFF090D16);
  static const Color bgDarkSecondary = Color(0xFF131C2E);
  static const Color bgDarkTertiary = Color(0xFF1E293B);

  // Glassmorphism Values
  static Color glassBackground = Colors.white.withValues(alpha: 0.07);
  static Color glassBackgroundActive = Colors.white.withValues(alpha: 0.12);
  static Color glassBorder = Colors.white.withValues(alpha: 0.16);
  static Color glassBorderSubtle = Colors.white.withValues(alpha: 0.08);

  // Accents
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentIndigo = Color(0xFF818CF8);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Helper for magnitude color
  static Color getMagnitudeColor(double magnitude) {
    if (magnitude >= 6.0) {
      return accentRose; // Bahaya / Sangat Kuat
    } else if (magnitude >= 5.0) {
      return accentAmber; // Menengah / Waspada
    } else {
      return accentEmerald; // Ringan / Aman
    }
  }
}
