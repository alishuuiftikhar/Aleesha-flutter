import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

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
    // The provider already starts loading in constructor
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    // Wait for at least 3 seconds or until loading is done
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      _waitForLoading(provider),
    ]);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _waitForLoading(AppProvider provider) async {
    while (provider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.palette_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'CREATIVE',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'INSPIRATION',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 8,
                  ),
            ),
            const SizedBox(height: 60),
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
