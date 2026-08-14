import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://aotcmoddkajtwmsbogcn.supabase.co',
      anonKey: 'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  runApp(const PlantifyApp());
}

class PlantifyApp extends StatelessWidget {
  const PlantifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plantify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.premiumTheme,
      home: const OnboardingScreen(),
    );
  }
}
