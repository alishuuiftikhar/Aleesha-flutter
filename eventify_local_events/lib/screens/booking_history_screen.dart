import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: bookings.isEmpty
          ? const Center(child: Text('No booking history found.', style: TextStyle(color: AppTheme.secondaryText)))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(booking.event.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.event.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                            Text(
                              DateFormat('dd MMM, yyyy').format(booking.bookingDate),
                              style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${booking.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
