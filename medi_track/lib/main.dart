import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://aotcmoddkajtwmsbogcn.supabase.co',
    anonKey: 'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediTrack',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}