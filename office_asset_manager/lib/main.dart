import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'supabase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/employees_list_screen.dart';
import 'screens/departments_list_screen.dart';
import 'screens/profile_settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/maintenance_records_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jtwbrngtiihkkzhpjecl.supabase.co',
    anonKey: 'sb_publishable_djeRN-zE5IGImgWxdfE7Zg_9r1UeO-O',
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SupabaseService>(create: (_) => SupabaseService()),
      ],
      child: const OfficeAssetManagerApp(),
    ),
  );
}

class OfficeAssetManagerApp extends StatelessWidget {
  const OfficeAssetManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Office Asset Manager',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/employees': (context) => const EmployeesListScreen(),
        '/departments': (context) => const DepartmentsListScreen(),
        '/profile': (context) => const ProfileSettingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/maintenance': (context) => const MaintenanceRecordsScreen(),
      },
    );
  }
}
