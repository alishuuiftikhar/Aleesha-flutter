import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFFFF8E7);
  static const Color secondaryBackground = Color(0xFFFFECC7);
  static const Color cardBackground = Color(0xFFFFFDF5);
  static const Color primary = Color(0xFFB45309);
  static const Color secondary = Color(0xFFD97706);
  static const Color accent = Color(0xFF287C8E);
  static const Color text = Color(0xFF3D2B1F);
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.accent,
    surface: AppColors.mainBackground,
    onSurface: AppColors.text,
  ),
  scaffoldBackgroundColor: AppColors.mainBackground,
  cardTheme: CardThemeData(
    color: AppColors.cardBackground,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: AppColors.text,
    displayColor: AppColors.text,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);
