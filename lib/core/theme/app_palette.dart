import 'package:flutter/material.dart';
import 'app_theme_type.dart';

class AppPalette extends ThemeExtension<AppPalette> {
  final AppThemeType themeType;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color work;
  final Color workSubtle;
  final Color rest;
  final Color restSubtle;
  final Color prepare;
  final Color prepareSubtle;
  final Color complete;
  final Color completeSubtle;
  final Color actionPrimary;
  final Color actionPrimaryText;
  final Color actionSecondary;
  final Color actionSecondaryText;
  final Brightness brightness;

  const AppPalette({
    required this.themeType,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.work,
    required this.workSubtle,
    required this.rest,
    required this.restSubtle,
    required this.prepare,
    required this.prepareSubtle,
    required this.complete,
    required this.completeSubtle,
    required this.actionPrimary,
    required this.actionPrimaryText,
    required this.actionSecondary,
    required this.actionSecondaryText,
    required this.brightness,
  });

  static const AppPalette carbon = AppPalette(
    themeType: AppThemeType.carbon,
    background: Color(0xFF0D0E11),
    surface: Color(0xFF16181D),
    surfaceElevated: Color(0xFF1E2127),
    border: Color(0xFF282C35),
    borderSubtle: Color(0xFF1F2229),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFF9196A1),
    textTertiary: Color(0xFF5D626E),
    work: Color(0xFFFF5222),
    workSubtle: Color(0x1FFF5222),
    rest: Color(0xFF14B8A6),
    restSubtle: Color(0x1F14B8A6),
    prepare: Color(0xFFF59E0B),
    prepareSubtle: Color(0x1FF59E0B),
    complete: Color(0xFF6366F1),
    completeSubtle: Color(0x1F6366F1),
    actionPrimary: Color(0xFFF3F4F6),
    actionPrimaryText: Color(0xFF0D0E11),
    actionSecondary: Color(0xFF20232B),
    actionSecondaryText: Color(0xFFE5E7EB),
    brightness: Brightness.dark,
  );

  static const AppPalette pastelRose = AppPalette(
    themeType: AppThemeType.pastelRose,
    background: Color(0xFFFAF4F5),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF4EAEB),
    border: Color(0xFFE8D7DA),
    borderSubtle: Color(0xFFF2E7E9),
    textPrimary: Color(0xFF2D2325),
    textSecondary: Color(0xFF7A6A6E),
    textTertiary: Color(0xFFA8989C),
    work: Color(0xFFD9777F),        // Soft dusty rose (calm, zero neon)
    workSubtle: Color(0x24D9777F),
    rest: Color(0xFF7FA498),        // Muted sea salt sage
    restSubtle: Color(0x247FA498),
    prepare: Color(0xFFD1A176),     // Warm sand / biscuit
    prepareSubtle: Color(0x24D1A176),
    complete: Color(0xFF9F8AB0),    // Muted heather lilac
    completeSubtle: Color(0x249F8AB0),
    actionPrimary: Color(0xFFD9777F),
    actionPrimaryText: Color(0xFFFFFFFF),
    actionSecondary: Color(0xFFF4EAEB),
    actionSecondaryText: Color(0xFF2D2325),
    brightness: Brightness.light,
  );

  static AppPalette ofType(AppThemeType type) {
    switch (type) {
      case AppThemeType.carbon:
        return carbon;
      case AppThemeType.pastelRose:
        return pastelRose;
    }
  }

  @override
  ThemeExtension<AppPalette> copyWith({
    AppThemeType? themeType,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? work,
    Color? workSubtle,
    Color? rest,
    Color? restSubtle,
    Color? prepare,
    Color? prepareSubtle,
    Color? complete,
    Color? completeSubtle,
    Color? actionPrimary,
    Color? actionPrimaryText,
    Color? actionSecondary,
    Color? actionSecondaryText,
    Brightness? brightness,
  }) {
    return AppPalette(
      themeType: themeType ?? this.themeType,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      work: work ?? this.work,
      workSubtle: workSubtle ?? this.workSubtle,
      rest: rest ?? this.rest,
      restSubtle: restSubtle ?? this.restSubtle,
      prepare: prepare ?? this.prepare,
      prepareSubtle: prepareSubtle ?? this.prepareSubtle,
      complete: complete ?? this.complete,
      completeSubtle: completeSubtle ?? this.completeSubtle,
      actionPrimary: actionPrimary ?? this.actionPrimary,
      actionPrimaryText: actionPrimaryText ?? this.actionPrimaryText,
      actionSecondary: actionSecondary ?? this.actionSecondary,
      actionSecondaryText: actionSecondaryText ?? this.actionSecondaryText,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  ThemeExtension<AppPalette> lerp(covariant ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      themeType: t < 0.5 ? themeType : other.themeType,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      work: Color.lerp(work, other.work, t)!,
      workSubtle: Color.lerp(workSubtle, other.workSubtle, t)!,
      rest: Color.lerp(rest, other.rest, t)!,
      restSubtle: Color.lerp(restSubtle, other.restSubtle, t)!,
      prepare: Color.lerp(prepare, other.prepare, t)!,
      prepareSubtle: Color.lerp(prepareSubtle, other.prepareSubtle, t)!,
      complete: Color.lerp(complete, other.complete, t)!,
      completeSubtle: Color.lerp(completeSubtle, other.completeSubtle, t)!,
      actionPrimary: Color.lerp(actionPrimary, other.actionPrimary, t)!,
      actionPrimaryText: Color.lerp(actionPrimaryText, other.actionPrimaryText, t)!,
      actionSecondary: Color.lerp(actionSecondary, other.actionSecondary, t)!,
      actionSecondaryText: Color.lerp(actionSecondaryText, other.actionSecondaryText, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
    );
  }
}
