import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduExam Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEEF2FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
          primary: const Color(0xFF3949AB),
          secondary: const Color(0xFF5C6BC0),
          tertiary: const Color(0xFFF9A825),
          surface: const Color(0xFFEEF2FF),
          onSurface: const Color(0xFF252B4A),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF252B4A), fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF252B4A)),
          bodyMedium: TextStyle(color: Color(0xFF252B4A)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3949AB),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3949AB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFF8F9FF),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
