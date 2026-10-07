import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds & Surfaces (Matte Carbon / Swiss Dark)
  static const Color background = Color(0xFF0D0E11);
  static const Color surface = Color(0xFF16181D);
  static const Color surfaceElevated = Color(0xFF1E2127);
  static const Color border = Color(0xFF282C35);
  static const Color borderSubtle = Color(0xFF1F2229);

  // Typography
  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9196A1);
  static const Color textTertiary = Color(0xFF5D626E);

  // Phase Accents (Minimal, intentional, high-contrast)
  static const Color work = Color(0xFFFF5222);       // Athletic vermilion
  static const Color workSubtle = Color(0x1FFF5222);
  static const Color rest = Color(0xFF14B8A6);       // Mineral teal
  static const Color restSubtle = Color(0x1F14B8A6);
  static const Color prepare = Color(0xFFF59E0B);    // Ochre amber
  static const Color prepareSubtle = Color(0x1FF59E0B);
  static const Color complete = Color(0xFF6366F1);   // Cobalt indigo
  static const Color completeSubtle = Color(0x1F6366F1);

  // Controls & Action Buttons
  static const Color actionPrimary = Color(0xFFF3F4F6);
  static const Color actionPrimaryText = Color(0xFF0D0E11);
  static const Color actionSecondary = Color(0xFF20232B);
  static const Color actionSecondaryText = Color(0xFFE5E7EB);
  static const Color destructive = Color(0xFFEF4444);
}
