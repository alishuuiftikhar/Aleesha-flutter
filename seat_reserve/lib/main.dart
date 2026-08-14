import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme.dart';
import 'models.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'admin_dashboard.dart';
import 'student_dashboard.dart';
import 'role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Using the new Supabase Publishable Key provided by the user
    await Supabase.initialize(
      url: 'https://aotcmoddkajtwmsbogcn.supabase.co',
      anonKey: 'sb_publishable_Ccp7hE0ppgcT97Vv_ppqeg_hi9cxc6G', 
    );
  } catch (e) {
    debugPrint('Supabase Init Error: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const SeatReserveApp(),
    ),
  );
}

class SeatReserveApp extends StatelessWidget {
  const SeatReserveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeatFlow',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/admin': (context) => const AdminDashboard(),
        '/student': (context) => const StudentDashboard(),
      },
    );
  }
}
