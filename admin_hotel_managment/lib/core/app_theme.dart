import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF0F4C81),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F4C81),
        primary: const Color(0xFF0F4C81),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    );
  }
}