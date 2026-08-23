import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/car_service.dart';
import '../theme/app_colors.dart';
import 'booking_screen.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.mainBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: car['image_url'] ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.secondaryBackground),
              ),
            ),
            actions: [
              Consumer<CarService>(
                builder: (context, carService, child) {
                  return FutureBuilder<bool>(
                    future: carService.isFavorite(car['id']),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? AppColors.error : Colors.white),
                        onPressed: () => carService.toggleFavorite(car['id']),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.mainBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car['name'] ?? '', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.mainText)),
                          Text(car['brand'] ?? '', style: const TextStyle(fontSize: 16, color: AppColors.secondaryText)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.secondaryBackground, borderRadius: BorderRadius.circular(12)),
                        child: Text('\$${car['price_per_day']}/day', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Specifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainText)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _specItem(context, Icons.speed, 'Max Speed', car['max_speed'] ?? '240 km/h'),
                      _specItem(context, Icons.bolt, 'Power', car['power'] ?? '450 HP'),
                      _specItem(context, Icons.timer, '0-100 km/h', car['acceleration'] ?? '4.2s'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainText)),
                  const SizedBox(height: 16),
                  Text(
                    car['description'] ?? 'No description available for this luxury vehicle. Enjoy a premium experience with the best features and performance.',
                    style: const TextStyle(color: AppColors.secondaryText, height: 1.5),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.mainBackground,
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(car: car))),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('BOOK NOW', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _specItem(BuildContext context, IconData icon, String title, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.mainText)),
        ],
      ),
    );
  }
}
