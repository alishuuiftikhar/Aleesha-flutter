import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color mainBg = Color(0xFFFFF0E5);
  static const Color secondaryBg = Color(0xFFFFDCC8);
  static const Color cardBg = Color(0xFFFFF9F4);
  static const Color primary = Color(0xFFC05621);
  static const Color secondary = Color(0xFFDD6B20);
  static const Color accent = Color(0xFF319795);
  static const Color text = Color(0xFF402218);
}

class AppTextStyles {
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  
  static TextStyle subHeading = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.text,
  );

  static TextStyle label = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.text.withOpacity(0.7),
  );
}
