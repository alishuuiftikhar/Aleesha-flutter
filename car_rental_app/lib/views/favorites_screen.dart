import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/car_service.dart';
import '../theme/app_colors.dart';
import '../widgets/car_card.dart';
import 'car_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: Consumer<CarService>(
        builder: (context, carService, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: carService.getFavorites(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final favorites = snapshot.data ?? [];
              if (favorites.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border_rounded, size: 80, color: AppColors.secondaryText),
                      SizedBox(height: 16),
                      Text('No favorites yet', style: TextStyle(color: AppColors.secondaryText, fontSize: 18)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final car = favorites[index];
                  return CarCard(
                    car: car,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car))),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
