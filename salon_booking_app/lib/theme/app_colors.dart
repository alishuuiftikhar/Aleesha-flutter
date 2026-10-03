import 'package:flutter/material.dart';

class AppColors {
  // STRICT ROSE PINK + WHITE LUXURY THEME
  static const Color primary = Color(0xFFD94F7D);   // Primary Rose Pink
  static const Color deepRose = Color(0xFFA8325C); // Deep Rose
  static const Color softRose = Color(0xFFFCE7EF); // Soft Rose
  static const Color white = Color(0xFFFFFFFF);     // Pure White
  static const Color background = Color(0xFFFFF8FA); // Very Light Pink Background
  static const Color card = Color(0xFFFFFFFF);

  static const Color mainText = Color(0xFF4A1020);  // Dark Burgundy-Rose for text
  static const Color secondaryText = Color(0xFF8E5B6B); // Muted Rose for secondary text

  static const Color success = Color(0xFF2E7D32); // Standard success but can use brand if preferred
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);

  // Gradient based on new theme
  static const LinearGradient luxuryGradient = LinearGradient(
    colors: [primary, deepRose],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
