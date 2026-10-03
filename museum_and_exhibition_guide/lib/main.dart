import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_provider.dart';
import 'utils/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuseumApp());
}

class MuseumApp extends StatelessWidget {
  const MuseumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Museum Guide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.mainBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.cardBackground,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(color: AppColors.text),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.mainBackground,
            foregroundColor: AppColors.text,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
