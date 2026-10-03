import 'package:flutter/material.dart';

class AppConstants {
  static const String supabaseUrl = 'https://jtwbrngtiihkkzhpjecl.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_djeRN-zE5IGImgWxdfE7Zg_9r1UeO-O';

  // Colors
  static const Color mainBackground = Color(0xFFF5EFE6);
  static const Color secondaryBackground = Color(0xFFE4D5C1);
  static const Color cardBackground = Color(0xFFFBF7F0);
  static const Color primaryColor = Color(0xFF6D4C41);
  static const Color secondaryColor = Color(0xFFA1887F);
  static const Color accentColor = Color(0xFF2A9D8F);
  static const Color highlightColor = Color(0xFFE9A23B);
  static const Color textColor = Color(0xFF342821);
  static const Color successColor = Color(0xFF4F9D69);
  static const Color errorColor = Color(0xFFD65A5A);

  // Statuses
  static const List<String> productionStatuses = [
    'Pending',
    'Scheduled',
    'In Production',
    'Paused',
    'Completed',
    'Cancelled',
  ];
}
