import 'package:flutter/material.dart';
import 'package:urban_drive_car_rental/theme/app_theme.dart';
import 'package:urban_drive_car_rental/screens/onboarding_screen.dart';
import 'package:urban_drive_car_rental/screens/home_screen.dart';
import 'package:urban_drive_car_rental/services/booking_service.dart';

import 'package:urban_drive_car_rental/services/user_service.dart';
import 'package:urban_drive_car_rental/services/saved_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookingService().init();
  await UserService().init();
  await SavedService().init();
  runApp(const UrbanDriveApp());
}

class UrbanDriveApp extends StatelessWidget {
  const UrbanDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Drive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
