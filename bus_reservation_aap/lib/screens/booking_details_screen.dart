import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/database_helper.dart';

class BookingDetailsScreen extends StatelessWidget {
  final int bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DatabaseHelper.instance.getBookingDetails(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Error loading details'));

          final booking = snapshot.data!;
          final bool canCancel = booking['status'] != 'Cancelled';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('BOOKING ID: ${booking['bookingId']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                          Text(booking['status'], style: TextStyle(color: booking['status'] == 'Cancelled' ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 30),
                      _detailItem('Bus', booking['busName']),
                      _detailItem('Route', '${booking['departureCity']} to ${booking['destinationCity']}'),
                      _detailItem('Date & Time', '${booking['date']} at ${booking['departureTime']}'),
                      _detailItem('Seats', (booking['seats'] as List).join(', ')),
                      const Divider(height: 30),
                      _detailItem('Passenger', booking['passengerName']),
                      _detailItem('Phone', booking['passengerPhone']),
                      _detailItem('Email', booking['passengerEmail']),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Paid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${booking['totalAmount']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (canCancel)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showCancelDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('CANCEL BOOKING'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this reservation? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('NO')),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.cancelBooking(bookingId);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to list
              }
            },
            child: const Text('YES, CANCEL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
