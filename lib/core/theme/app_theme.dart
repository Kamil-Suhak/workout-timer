import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart';
import 'app_theme_type.dart';

class AppTheme {
  AppTheme._();

  static ThemeData buildTheme(AppThemeType type) {
    final palette = AppPalette.ofType(type);
    final isDark = palette.brightness == Brightness.dark;

    return ThemeData(
      brightness: palette.brightness,
      scaffoldBackgroundColor: palette.background,
      primaryColor: palette.actionPrimary,
      canvasColor: palette.surface,
      cardColor: palette.surface,
      extensions: [palette],
      colorScheme: ColorScheme(
        brightness: palette.brightness,
        primary: palette.actionPrimary,
        onPrimary: palette.actionPrimaryText,
        secondary: palette.work,
        onSecondary: Colors.white,
        error: const Color(0xFFEF4444),
        onError: Colors.white,
        surface: palette.surface,
        onSurface: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: palette.textPrimary),
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.borderSubtle,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme => buildTheme(AppThemeType.carbon);
  static ThemeData get pastelRoseTheme => buildTheme(AppThemeType.pastelRose);
}
