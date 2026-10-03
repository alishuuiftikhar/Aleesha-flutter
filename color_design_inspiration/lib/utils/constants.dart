import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFF3F0FF);
  static const Color secondaryBackground = Color(0xFFDED7F5);
  static const Color cardBackground = Color(0xFFFBFAFF);
  static const Color primary = Color(0xFF3D348B);
  static const Color secondary = Color(0xFF7678ED);
  static const Color accent = Color(0xFFF18701);
  static const Color text = Color(0xFF29233D);
  static const Color textLight = Color(0xFF6B6580);
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
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: AppColors.text),
        bodyMedium: GoogleFonts.poppins(color: AppColors.text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
