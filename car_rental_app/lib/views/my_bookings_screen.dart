import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import '../theme/app_colors.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: Consumer<BookingService>(
        builder: (context, bookingService, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: bookingService.getUserBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final bookings = snapshot.data ?? [];
              if (bookings.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 80, color: AppColors.secondaryText),
                      SizedBox(height: 16),
                      Text('No bookings found', style: TextStyle(color: AppColors.secondaryText, fontSize: 18)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final car = booking['cars'];
                  final startDate = DateTime.parse(booking['start_date']);
                  final endDate = DateTime.parse(booking['end_date']);
                  final status = booking['status'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(car['image_url'], width: 80, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(car['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text('\$${booking['total_amount']}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'confirmed' ? AppColors.success.withOpacity(0.2) : AppColors.error.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(color: status == 'confirmed' ? AppColors.success : AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.secondaryBackground),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Date Range', style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                                Text('${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}', style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                            if (status == 'confirmed' && startDate.isAfter(DateTime.now()))
                              TextButton(
                                onPressed: () => _confirmCancel(context, bookingService, booking['id']),
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

  void _confirmCancel(BuildContext context, BookingService service, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NO')),
          TextButton(
            onPressed: () async {
              await service.cancelBooking(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('YES, CANCEL', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
