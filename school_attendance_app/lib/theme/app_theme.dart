import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color mainBackground = Color(0xFFF0F7FF);
  static const Color secondaryBackground = Color(0xFFDCEEFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF2878C8);
  static const Color secondary = Color(0xFF4A9FE8);
  static const Color accent = Color(0xFFFFB703);
  static const Color text = Color(0xFF18324B);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: mainBackground,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: cardBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: text,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: TextStyle(color: text, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: text, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: text,
      ),
    );
  }
}
