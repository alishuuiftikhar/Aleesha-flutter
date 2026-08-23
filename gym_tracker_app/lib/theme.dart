import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFF0F1115); // Very dark charcoal
  static const Color cardBackground = Color(0xFF1A1D24); // Graphite
  static const Color primary = Color(0xFFE63946);        // Crimson red
  static const Color secondary = Color(0xFF8B1E2D);      // Dark red
  static const Color accent = Color(0xFFFF6B6B);
  static const Color mainText = Color(0xFFF5F5F5);
  static const Color secondaryText = Color(0xFFA7ADB7);
  static const Color divider = Color(0xFF2A2E38);        // Visible divider
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE63946);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.mainBackground,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.divider,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackground,
        background: AppColors.mainBackground,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: const TextStyle(color: AppColors.mainText),
        bodyMedium: const TextStyle(color: AppColors.mainText),
        titleLarge: const TextStyle(color: AppColors.mainText, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bebasNeue(
          color: AppColors.mainText,
          fontSize: 24,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.mainText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
        prefixIconColor: AppColors.secondaryText,
      ),
    );
  }
}
