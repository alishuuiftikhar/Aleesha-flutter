import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VehicleServiceApp());
}

class VehicleServiceApp extends StatelessWidget {
  const VehicleServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Service Pro',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}
