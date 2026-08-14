import 'package:flutter/material.dart';
import 'package:urban_drive_car_rental/theme/app_theme.dart';
import 'package:urban_drive_car_rental/services/saved_service.dart';
import 'package:urban_drive_car_rental/widgets/car_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Cars'),
      ),
      body: ListenableBuilder(
        listenable: SavedService(),
        builder: (context, child) {
          final savedCars = SavedService().getSavedCars();

          if (savedCars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, 
                       size: 80, 
                       color: AppTheme.primaryPurple.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved cars yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the heart icon on any car to save it here.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: savedCars.length,
            itemBuilder: (context, index) {
              return CarCard(car: savedCars[index]);
            },
          );
        },
      ),
    );
  }
}
