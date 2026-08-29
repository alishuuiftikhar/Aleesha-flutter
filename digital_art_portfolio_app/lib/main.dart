import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => PortfolioProvider(),
      child: const DigitalArtPortfolioApp(),
    ),
  );
}

class DigitalArtPortfolioApp extends StatelessWidget {
  const DigitalArtPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aleesha Creative Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Start data loading and the 8-second delay in parallel
    await Future.wait([
      _loadInitialData(),
      Future.delayed(const Duration(seconds: 8)),
    ]);

    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      // Use the microtask to ensure context is ready
      await Future.microtask(() async {
        if (mounted) {
          await context.read<PortfolioProvider>().loadData();
        }
      });
    } catch (e) {
      debugPrint("Initialization Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: _showSplash 
          ? const SplashScreen(key: ValueKey('splash')) 
          : const HomeScreen(key: ValueKey('home')),
    );
  }
}
