import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.deepRose,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.mainText,
        error: AppColors.error,
        onError: AppColors.white,
        surfaceContainerHighest: AppColors.softRose,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2.0,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.mainText,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.mainText,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: AppColors.mainText,
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          color: AppColors.mainText,
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
        bodyLarge: GoogleFonts.lato(
          color: AppColors.mainText,
          fontSize: 16.0,
        ),
        bodyMedium: GoogleFonts.lato(
          color: AppColors.secondaryText,
          fontSize: 14.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 56.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          textStyle: GoogleFonts.lato(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        hintStyle: GoogleFonts.lato(color: AppColors.secondaryText.withOpacity(0.5)),
        prefixIconColor: AppColors.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 10.0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.secondaryText.withOpacity(0.5),
        indicatorColor: AppColors.primary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.deepRose,
        onSecondary: AppColors.white,
        surface: Color(0xFF1A1A1A),
        onSurface: AppColors.softRose,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
