import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'core/constants/supabase_constants.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConstants.url,
    anonKey: SupabaseConstants.anonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SupabaseService()),
      ],
      child: const SportsClubApp(),
    ),
  );
}

class SportsClubApp extends StatelessWidget {
  const SportsClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Club Manager',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
