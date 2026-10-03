import 'package:flutter/material.dart';

class AppTheme {
  static const Color mainBackground = Color(0xFFEAF2F0);
  static const Color secondaryBackground = Color(0xFFD2E3DF);
  static const Color cardBackground = Color(0xFFF7FBFA);
  static const Color primaryColor = Color(0xFF355070);
  static const Color secondaryColor = Color(0xFF527B8A);
  static const Color accentColor = Color(0xFFE9C46A);
  static const Color textColor = Color(0xFF263A42);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: mainBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: textColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: textColor,
      ),
    );
  }
}
