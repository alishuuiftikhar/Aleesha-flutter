import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFF0FAF4);
  static const Color secondaryBackground = Color(0xFFD8F3E2);
  static const Color cardBackground = Color(0xFFF8FFFA);
  static const Color primary = Color(0xFF2F855A);
  static const Color secondary = Color(0xFF48BB78);
  static const Color accent = Color(0xFFED8936);
  static const Color text = Color(0xFF1F3D2B);
  
  static const List<Color> habitColors = [
    Color(0xFF48BB78), // Emerald
    Color(0xFFED8936), // Peach/Orange
    Color(0xFF4299E1), // Blue
    Color(0xFFF6AD55), // Light Peach
    Color(0xFF667EEA), // Indigo
    Color(0xFFF687B3), // Pink
  ];
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.mainBackground,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.cardBackground,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.text),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: AppColors.secondaryBackground.withOpacity(0.5)),
    ),
  ),
);
