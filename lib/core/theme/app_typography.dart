import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Display timer countdown digits with tabular numbers to prevent jitter
  static const TextStyle timerHuge = TextStyle(
    fontSize: 88,
    fontWeight: FontWeight.w700,
    letterSpacing: -2.5,
    height: 1.0,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timerLarge = TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.05,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timerMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Labels and metadata
  static const TextStyle phaseLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    color: AppColors.textSecondary,
  );

  static const TextStyle setCounter = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.textTertiary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
