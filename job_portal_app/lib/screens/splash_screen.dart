import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'auth/login_screen.dart';
import 'seeker/seeker_main_screen.dart';
import 'employer/employer_main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 9));
    final session = SupabaseService.client.auth.currentSession;

    if (!mounted) return;

    if (session == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      final userId = session.user.id;
      final profile = await SupabaseService.getProfile(userId);
      
      if (!mounted) return;

      String? role;
      if (profile != null) {
        role = profile['role'];
      } else {
        role = session.user.userMetadata?['role'];
      }

      if (role == 'employer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmployerMainScreen()),
        );
      } else if (role == 'seeker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SeekerMainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 80, color: Color(0xFF176B87)),
            SizedBox(height: 16),
            Text(
              'JobPortal',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF176B87),
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
