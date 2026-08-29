import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/travel_provider.dart';
import '../theme.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: Consumer<TravelProvider>(
        builder: (context, provider, _) {
          if (provider.bookings.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.bookings.length,
            itemBuilder: (context, index) {
              final booking = provider.bookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: TravelTheme.bgSecondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            booking.destination.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.destination.name,
                                style: const TextStyle(
                                  color: TravelTheme.textMain,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Travel Date: ${DateFormat('MMM dd, yyyy').format(booking.travelDate)}',
                                style: const TextStyle(color: TravelTheme.accent, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: TravelTheme.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Confirmed',
                            style: TextStyle(color: TravelTheme.success, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(color: TravelTheme.textSecondary, fontSize: 12),
                            ),
                            Text(
                              '\$${booking.totalPrice}',
                              style: const TextStyle(
                                color: TravelTheme.textMain,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => _showCancelDialog(context, provider, booking.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: TravelTheme.secondary),
                            foregroundColor: TravelTheme.secondary,
                            elevation: 0,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.airplane_ticket_outlined, size: 80, color: TravelTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 15),
          const Text(
            'No bookings found',
            style: TextStyle(color: TravelTheme.textSecondary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, TravelProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TravelTheme.bgSecondary,
        title: const Text('Cancel Booking', style: TextStyle(color: TravelTheme.textMain)),
        content: const Text(
          'Are you sure you want to cancel this booking?',
          style: TextStyle(color: TravelTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: TravelTheme.textMain)),
          ),
          TextButton(
            onPressed: () {
              provider.cancelBooking(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking Cancelled')),
              );
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: TravelTheme.secondary)),
          ),
        ],
      ),
    );
  }
}
