import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seats_reserve/core/constants.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/screens/student/student_navbar.dart';
import 'package:seats_reserve/screens/admin/admin_navbar.dart';
import 'package:seats_reserve/screens/auth/pending_approval_screen.dart';

import 'package:seats_reserve/screens/auth/role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const SeatSyncApp(),
    ),
  );
}

class SeatSyncApp extends StatelessWidget {
  const SeatSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeatSync',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!authProvider.isAuthenticated) {
      return const RoleSelectionScreen();
    }

    if (authProvider.userProfile == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                const Text(
                  'Loading your account...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If this takes too long, please check your internet or try logging in again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => authProvider.fetchProfile(),
                  child: const Text('Try Again'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => authProvider.signOut(),
                  child: const Text('Logout & Start Over'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final profile = authProvider.userProfile!;

    if (profile.role == AppConstants.roleAdmin) {
      return const AdminNavbar();
    } else {
      if (profile.status == AppConstants.statusPending) {
        return const PendingApprovalScreen();
      } else if (profile.status == AppConstants.statusApproved) {
        return const StudentNavbar();
      } else {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Access Restricted',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your account status is "${profile.status.toUpperCase()}". Please contact the administrator.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => authProvider.signOut(),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
