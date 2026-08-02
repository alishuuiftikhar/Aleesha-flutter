import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

// 1. Yahan Global Declare karein (main() function se pehle)
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
ValueNotifier<String> currencyNotifier = ValueNotifier('\$');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://aotcmoddkajtwmsbogcn.supabase.co',
    anonKey:'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. ThemeNotifier ko yahan use karein taake dark/light mode chale
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          themeMode: currentTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: Colors.grey[100],
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
          ),
          home: Supabase.instance.client.auth.currentSession == null
              ? const AuthScreen()
              : const HomeScreen(),
        );
      },
    );
  }
}