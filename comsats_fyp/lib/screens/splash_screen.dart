import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84, height: 84,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.school, color: AppColors.primary, size: 44),
            ),
            const SizedBox(height: 20),
            const Text('COMSATS FYP Portal',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Vehari Campus', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 32),
            const SizedBox(
              width: 26, height: 26,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
            ),
          ],
        ),
      ),
    );
  }
}
