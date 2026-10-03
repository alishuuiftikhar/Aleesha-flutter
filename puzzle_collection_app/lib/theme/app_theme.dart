import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFFFFBEA);
  static const Color secondaryBackground = Color(0xFFFFF0B8);
  static const Color cardBackground = Color(0xFFFFFDF5);
  static const Color primary = Color(0xFF6B4F9A);
  static const Color secondary = Color(0xFF8A68B8);
  static const Color accent = Color(0xFFE76F51);
  static const Color text = Color(0xFF332C3A);
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
