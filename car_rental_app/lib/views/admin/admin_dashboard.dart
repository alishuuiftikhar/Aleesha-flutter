import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/car_service.dart';
import '../../services/booking_service.dart';
import '../../theme/app_colors.dart';
import 'add_edit_car_screen.dart';
import 'manage_bookings_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _adminCard(
              context,
              'Manage Cars',
              'Add, edit or delete cars from the catalog',
              Icons.directions_car_rounded,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageCarsScreen())),
            ),
            const SizedBox(height: 20),
            _adminCard(
              context,
              'Manage Bookings',
              'View and update status of all bookings',
              Icons.book_online_rounded,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageBookingsScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class ManageCarsScreen extends StatelessWidget {
  const ManageCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCarScreen())),
          ),
        ],
      ),
      body: Consumer<CarService>(
        builder: (context, carService, child) {
          if (carService.isLoading) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: carService.cars.length,
            itemBuilder: (context, index) {
              final car = carService.cars[index];
              return ListTile(
                leading: Image.network(car['image_url'], width: 50, height: 40, fit: BoxFit.cover),
                title: Text(car['name']),
                subtitle: Text('\$${car['price_per_day']}/day'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, color: AppColors.secondary),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditCarScreen(car: car))),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                      onPressed: () => carService.deleteCar(car['id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
