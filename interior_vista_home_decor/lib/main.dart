import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'models/app_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://aotcmoddkajtwmsbogcn.supabase.co',
    anonKey: 'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G',
  );

  // Load saved data
  await AppData.loadWishlist();

  runApp(const InteriorApp());
}

class InteriorApp extends StatefulWidget {
  const InteriorApp({super.key});

  @override
  State<InteriorApp> createState() => InteriorAppState();
  
  static InteriorAppState of(BuildContext context) => 
      context.findAncestorStateOfType<InteriorAppState>()!;
}

class InteriorAppState extends State<InteriorApp> {
  ThemeMode _themeMode = AppData.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      AppData.isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InteriorVista Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF06292),
          primary: const Color(0xFFF06292),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF06292),
          brightness: Brightness.dark,
          primary: const Color(0xFFF06292),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SplashScreen(),
    );
  }
}
