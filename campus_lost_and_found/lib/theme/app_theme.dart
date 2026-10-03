import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFE8F0E8);
  static const Color secondaryBackground = Color(0xFFD1E0D0);
  static const Color cardBackground = Color(0xFFE1ECE0);
  static const Color primary = Color(0xFF486B52);
  static const Color secondary = Color(0xFF6F9275);
  static const Color accent = Color(0xFFD28B45);
  static const Color highlight = Color(0xFF547C9D);
  static const Color text = Color(0xFF29362D);
  static const Color success = Color(0xFF5B9368);
  static const Color error = Color(0xFFC85D5D);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.mainBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: AppColors.mainBackground,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.text,
        onSurface: AppColors.text,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondaryBackground,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
