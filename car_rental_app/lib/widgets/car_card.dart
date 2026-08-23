import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/car_service.dart';
import '../theme/app_colors.dart';

class CarCard extends StatelessWidget {
  final Map<String, dynamic> car;
  final VoidCallback onTap;

  const CarCard({super.key, required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: car['image_url'] ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.secondaryBackground, child: const Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Container(color: AppColors.secondaryBackground, child: const Icon(Icons.error)),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Consumer<CarService>(
                    builder: (context, carService, child) {
                      return FutureBuilder<bool>(
                        future: carService.isFavorite(car['id']),
                        builder: (context, snapshot) {
                          final isFav = snapshot.data ?? false;
                          return CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: IconButton(
                              icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? AppColors.error : Colors.white),
                              onPressed: () => carService.toggleFavorite(car['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car['name'] ?? 'Car Name',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainText),
                      ),
                      Text(
                        '\$${car['price_per_day']}/day',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${car['brand']} • ${car['type']}',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoTag(Icons.settings, car['transmission'] ?? 'Auto'),
                      const SizedBox(width: 12),
                      _buildInfoTag(Icons.local_gas_station, car['fuel_type'] ?? 'Petrol'),
                      const SizedBox(width: 12),
                      _buildInfoTag(Icons.people, '${car['seats']} Seats'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTag(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
      ],
    );
  }
}
