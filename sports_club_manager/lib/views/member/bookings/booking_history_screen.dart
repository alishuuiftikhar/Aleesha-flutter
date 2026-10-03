import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final statuses = ['Confirmed', 'Cancelled', 'Completed'];
          final colors = [AppColors.success, AppColors.error, Colors.grey];
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: const Text('HIIT Training', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Nov 15, 2023 • 06:00 PM'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors[index % 3].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors[index % 3]),
                ),
                child: Text(
                  statuses[index % 3],
                  style: TextStyle(color: colors[index % 3], fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
