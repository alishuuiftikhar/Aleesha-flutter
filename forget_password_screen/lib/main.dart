import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:forget_password_screen/screens/splash_screen.dart';
import 'package:forget_password_screen/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase with the provided credentials
  await Supabase.initialize(
    url: 'https://necbzbnfgzlyvtyrulro.supabase.co',
    publishableKey: 'sb_publishable_aL7ifStDQyHmXgoOOlsscg_qGFlDjLY',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Auth',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
