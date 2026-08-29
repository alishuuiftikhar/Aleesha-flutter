import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelTheme {
  static const Color deepTurquoise = Color(0x0B3D46FF); // Corrected format if it was hex
  // Re-reading requirements: Main Background: #0B3D46
  static const Color bgMain = Color(0xFF0B3D46);
  static const Color bgSecondary = Color(0xFF12606A);
  static const Color cardBg = Color(0xFFE58F73);
  static const Color primary = Color(0xFF24C6B7);
  static const Color secondary = Color(0xFFFF8A65);
  static const Color accent = Color(0xFFF4D6A6);
  static const Color textMain = Color(0xFFFFF7EA);
  static const Color textSecondary = Color(0xFFD1E8E5);
  static const Color success = Color(0xFF55C98A);

  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: bgMain,
      primaryColor: primary,
      hintColor: accent,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textMain,
        displayColor: textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgMain,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: bgMain,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
