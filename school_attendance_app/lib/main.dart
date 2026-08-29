import 'package:flutter/material.dart';
import 'package:school_attendance_app/theme/app_theme.dart';
import 'package:school_attendance_app/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // I am using the full URL you provided now
    await Supabase.initialize(
      url: 'https://jtwbrngtiihkkzhpjecl.supabase.co',
      anonKey: 'sb_publishable_djeRN-zE5IGImgWxdfE7Zg_9r1UeO-O',
    );
  } catch (e) {
    print('Supabase Init Error: $e');
  }

  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Attendance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
