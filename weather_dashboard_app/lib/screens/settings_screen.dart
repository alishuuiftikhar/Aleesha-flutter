import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        titleTextStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Units',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.secondaryBackground),
              ),
              child: ListTile(
                title: const Text('Temperature Unit'),
                subtitle: Text(
                  provider.unit == TempUnit.celsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
                ),
                trailing: Switch(
                  value: provider.unit == TempUnit.fahrenheit,
                  onChanged: (value) => provider.toggleUnit(),
                  activeColor: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.secondaryBackground),
              ),
              child: const Text(
                'SkyCast is a professional weather dashboard built with Flutter. It provides real-time-like updates using local data and saves your preferences locally.',
                style: TextStyle(color: AppColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
