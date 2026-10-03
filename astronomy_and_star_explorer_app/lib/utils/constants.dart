import 'package:flutter/material.dart';

class AppColors {
  static const Color mainBackground = Color(0xFF182B3A);
  static const Color secondaryBackground = Color(0xFF24465A);
  static const Color cardBackground = Color(0xFF2D5266);
  static const Color primary = Color(0xFF67B7C9);
  static const Color secondary = Color(0xFF8ED1C7);
  static const Color accent = Color(0xFFF2C14E);
  static const Color highlight = Color(0xFFE98B5C);
  static const Color text = Color(0xFFF5EBDD);
  static const Color success = Color(0xFF75B798);
  static const Color error = Color(0xFFE27676);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.mainBackground,
        secondary: AppColors.secondary,
        onSecondary: AppColors.mainBackground,
        surface: AppColors.mainBackground,
        onSurface: AppColors.text,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.mainBackground,
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 32),
        headlineMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 20),
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.mainBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.mainBackground,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
