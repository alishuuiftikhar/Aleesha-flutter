import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFFFF1F2);
  static const Color secondaryBackground = Color(0xFFFFDDE1);
  static const Color cardBackground = Color(0xFFFFF9FA);
  static const Color primary = Color(0xFF9F1239);
  static const Color secondary = Color(0xFFBE185D);
  static const Color accent = Color(0xFF65A30D);
  static const Color text = Color(0x3B2029FF); // Corrected alpha? User gave #3B2029
  static const Color textMain = Color(0xFF3B2029);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.mainBackground,
      ),
      scaffoldBackgroundColor: AppColors.mainBackground,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: AppColors.textMain,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textMain,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textMain,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondaryBackground,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
