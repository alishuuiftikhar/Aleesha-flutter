import 'package:flutter/material.dart';

class AppTheme {
  static const Color burntOrange = Color(0xFFCC5500);
  static const Color warmBrown = Color(0xFF795548);
  static const Color cream = Color(0xFFFFFDD0);
  static const Color offWhite = Color(0xFFFAF9F6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: burntOrange,
        primary: burntOrange,
        secondary: warmBrown,
        surface: cream,
      ),
      scaffoldBackgroundColor: offWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: burntOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: burntOrange,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: cream,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: burntOrange, width: 2),
        ),
      ),
    );
  }
}
