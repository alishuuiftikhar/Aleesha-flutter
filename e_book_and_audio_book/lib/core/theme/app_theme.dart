import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Elegant Classic Library Theme (Warm & Professional)
  static const Color primaryColor = Color(0xFF2C1810); // Deep Espresso Brown
  static const Color secondaryColor = Color(0xFF8D6E63); // Muted Terracotta
  static const Color accentColor = Color(0xFFC5A028); // Antique Gold
  static const Color backgroundColor = Color(0xFFF9F7F2); // Warm Cream Paper
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF2C1810);
  static const Color textSecondaryColor = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSurface: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.philosopherTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
