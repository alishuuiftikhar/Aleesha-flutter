import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forget_password_screen/screens/login_screen.dart';
import 'package:forget_password_screen/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 100,
                color: Colors.white,
              ),
            )
            .animate()
            .scale(duration: 800.ms, curve: Curves.easeOutBack)
            .rotate(duration: 1200.ms),
            const SizedBox(height: 24),
            Text(
              'SECURELY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.5, end: 0),
            const SizedBox(height: 8),
            Text(
              'Authentication Reimagined',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
