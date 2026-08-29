import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/travel_provider.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Provider.of<TravelProvider>(context, listen: false).loadInitialData();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TravelTheme.bgMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: TravelTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flight_takeoff_rounded,
                size: 80,
                color: TravelTheme.bgMain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'TRAVEL ADVENTURE',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: TravelTheme.textMain,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore the world with us',
              style: TextStyle(
                fontSize: 16,
                color: TravelTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TravelTheme.accent),
            ),
          ],
        ),
      ),
    );
  }
}
