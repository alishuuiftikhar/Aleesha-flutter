import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFF123B3A);
  static const Color secondaryBackground = Color(0xFF1A514E);
  static const Color cardBackground = Color(0xFF276764);
  static const Color primary = Color(0xFF8B7CC8);
  static const Color secondary = Color(0xFFA99BD8);
  static const Color accent = Color(0xFF9FE2BF);
  static const Color highlight = Color(0xFFD7F5E8);
  static const Color mainText = Color(0xFFF3FFF9);
  static const Color secondaryText = Color(0xFFB8D8D1);
  static const Color success = Color(0xFF55D6A0);
  static const Color error = Color(0xFFFF6B7A);
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.mainBackground,
    cardColor: AppColors.cardBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardBackground,
      background: AppColors.mainBackground,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.mainText,
      onBackground: AppColors.mainText,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.mainText,
      displayColor: AppColors.mainText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.mainBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.mainText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.mainText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.secondaryText),
      labelStyle: const TextStyle(color: AppColors.secondaryText),
    ),
  );
}
