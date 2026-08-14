import 'package:flutter/material.dart';

class AppTheme {
  // Sophisticated Color Palette
  static const Color primaryNavy = Color(0xFF0F172A); // Midnight Navy
  static const Color accentAmber = Color(0xFFF59E0B); // Golden Amber
  static const Color accentOrange = Color(0xFFF97316); // Sunset Orange
  static const Color bgSoftWhite = Color(0xFFF8FAFC); // Very Light Gray/Blue
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryNavy,
      scaffoldBackgroundColor: bgSoftWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNavy,
        primary: primaryNavy,
        secondary: accentAmber,
        tertiary: accentOrange,
        surface: surfaceWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        color: surfaceWhite,
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceWhite,
        selectedColor: primaryNavy,
        labelStyle: const TextStyle(color: textDark, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: primaryNavy.withOpacity(0.3),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textDark, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textDark),
        bodyLarge: TextStyle(fontSize: 16, color: textDark, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: textLight, height: 1.5),
      ),
    );
  }

  // Helper for consistent shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get intenseShadow => [
        BoxShadow(
          color: primaryNavy.withOpacity(0.1),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ];
}
