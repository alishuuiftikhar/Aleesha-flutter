import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:'https://aotcmoddkajtwmsbogcn.supabase.co',
    anonKey:'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
  );
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return MaterialApp(
      title: 'Royal Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: session != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}