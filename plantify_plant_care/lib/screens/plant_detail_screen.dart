import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;
  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with proper fitting
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Hero(
              tag: 'plant-${plant.id}',
              child: Image.network(
                plant.imageUrl, 
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.softGreen,
                  child: const Center(child: Icon(Icons.broken_image, size: 50, color: AppTheme.primaryGreen)),
                ),
              ),
            ),
          ),
          
          // Back Button & Favorite
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(context, Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                  ListenableBuilder(
                    listenable: AppState(),
                    builder: (context, _) {
                      bool isFav = AppState().isFavorite(plant);
                      return _buildCircleButton(
                        context, 
                        isFav ? Icons.favorite : Icons.favorite_border, 
                        () => AppState().toggleFavorite(plant),
                        color: isFav ? Colors.red : AppTheme.primaryGreen,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Content sheet
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plant.name, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, height: 1.2)),
                                const SizedBox(height: 5),
                                Text(plant.species, style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 16)),
                              ],
                            ),
                          ),
                          Text(plant.price, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildCareSection(),
                      const SizedBox(height: 30),
                      const Text('About Plant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                      const SizedBox(height: 12),
                      Text(plant.description, style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15)),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                AppState().addToCart(plant);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${plant.name} added to cart!'),
                                    behavior: SnackBarBehavior.floating,
                                  )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              AppState().addReminder(plant, 'Daily at 8:00 AM');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reminder set!'), behavior: SnackBarBehavior.floating)
                              );
                            },
                            child: Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                color: AppTheme.softGreen, 
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.1)),
                              ),
                              child: const Icon(Icons.alarm_add_rounded, color: AppTheme.primaryGreen, size: 26),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4), 
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color ?? AppTheme.primaryGreen, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildCareSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCareCard(Icons.water_drop_rounded, 'Water', plant.water, Colors.blue),
        _buildCareCard(Icons.wb_sunny_rounded, 'Light', plant.light, Colors.orange),
        _buildCareCard(Icons.thermostat_rounded, 'Temp', plant.temperature, Colors.redAccent),
      ],
    );
  }

  Widget _buildCareCard(IconData icon, String label, String value, Color iconColor) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          const SizedBox(height: 2),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
        ],
      ),
    );
  }
}
