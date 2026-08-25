import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBackground = Color(0xFF1A2332);
  static const Color secondaryBackground = Color(0xFF25344A);
  static const Color cardBackground = Color(0xFF30445C);
  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFFA855F7);
  static const Color accent = Color(0xFF22D3EE);
  static const Color highlight = Color(0xFFF59E0B);
  static const Color mainText = Color(0xFFF8FAFC);
  static const Color secondaryText = Color(0xFFB8C4D6);
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFFB7185);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.mainBackground,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
        background: AppColors.mainBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.mainText,
        onBackground: AppColors.mainText,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.mainText, fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: AppColors.mainText, fontSize: 28, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: AppColors.mainText, fontSize: 20, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: AppColors.mainText, fontSize: 16),
          bodyMedium: TextStyle(color: AppColors.secondaryText, fontSize: 14),
          labelLarge: TextStyle(color: AppColors.mainText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.secondaryText),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
