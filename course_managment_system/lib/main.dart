import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:'https://aotcmoddkajtwmsbogcn.supabase.co',
    anonKey:'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
  );

  runApp(const CourseManagementApp());
}

class CourseManagementApp extends StatelessWidget {
  const CourseManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS Pro',
      debugShowCheckedModeBanner: false,
      // Steel Blue + White Professional Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F7F9), // Very Light Soft Steel/Grey-Blue background
        primaryColor: const Color(0xFF4682B4), // Classic Steel Blue
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4682B4), // Steel Blue
          secondary: Color(0xFFB0C4DE), // Light Steel Blue accent
          surface: Colors.white, // Pure White Cards & Containers
          onPrimary: Colors.white,
          onSurface: const Color(0xFF1E293B), // Dark text for high readability
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4682B4), // Steel Blue AppBar
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFF4682B4).withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4682B4), // Steel Blue Button
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDCDCDC))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4682B4), width: 2)),
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF334155)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}