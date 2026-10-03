import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFFFFF4E8);
  static const Color secondaryBackground = Color(0xFFF9DFC4);
  static const Color cardBackground = Color(0xFFFFF9F3);
  static const Color primary = Color(0xFF7B2D26);
  static const Color secondary = Color(0xFFC44536);
  static const Color accent = Color(0xFF277DA1);
  static const Color text = Color(0xFF3A2925);
  static const Color success = Color(0xFF4F9D69);
  static const Color warning = Color(0xFFE09F3E);
  static const Color error = Color(0xFFD62828);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.mainBackground,
        onSurface: AppColors.text,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.mainBackground,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
