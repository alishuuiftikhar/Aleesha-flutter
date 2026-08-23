import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/booking_service.dart';
import '../../theme/app_colors.dart';

class ManageBookingsScreen extends StatelessWidget {
  const ManageBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage All Bookings')),
      body: Consumer<BookingService>(
        builder: (context, bookingService, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: bookingService.getAllBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final bookings = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final car = booking['cars'];
                  final profile = booking['profiles'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(car['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(booking['status'].toUpperCase(), style: TextStyle(color: booking['status'] == 'confirmed' ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('User: ${profile['full_name']} (${profile['email']})', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                        Text('Dates: ${DateFormat('MMM dd').format(DateTime.parse(booking['start_date']))} - ${DateFormat('MMM dd').format(DateTime.parse(booking['end_date']))}', style: const TextStyle(fontSize: 12)),
                        const Divider(height: 24, color: AppColors.secondaryBackground),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (booking['status'] == 'pending')
                              TextButton(
                                onPressed: () => bookingService.updateBookingStatus(booking['id'], 'confirmed'),
                                child: const Text('Confirm', style: TextStyle(color: AppColors.success)),
                              ),
                            if (booking['status'] != 'cancelled')
                              TextButton(
                                onPressed: () => bookingService.updateBookingStatus(booking['id'], 'cancelled'),
                                child: const Text('Cancel', style: TextStyle(color: AppColors.error)),
                              ),
                          ],
                        ),
                      ],
                    ),
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
