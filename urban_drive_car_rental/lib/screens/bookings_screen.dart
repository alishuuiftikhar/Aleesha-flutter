import 'package:flutter/material.dart';
import 'package:urban_drive_car_rental/theme/app_theme.dart';
import 'package:urban_drive_car_rental/services/booking_service.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: ListenableBuilder(
        listenable: BookingService(),
        builder: (context, child) {
          final bookings = BookingService().bookings;

          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, 
                       size: 80, 
                       color: AppTheme.primaryPurple.withOpacity(0.2)),
                  const SizedBox(height: 24),
                  const Text(
                    'No active bookings',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: AppTheme.textPrimary
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your future bookings will appear here.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              
              String formattedTotal = booking.totalAmount.toInt().toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");

              final dateFormat = DateFormat('dd MMM yyyy');

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 110,
                              height: 85,
                              color: const Color(0xFFF1F5F9),
                              child: Image.network(
                                booking.carImage,
                                fit: BoxFit.contain, // Showing the WHOLE car in history
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        booking.status,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'ID: #${booking.id.substring(0, 6)}',
                                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  booking.carName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900, 
                                    fontSize: 18, 
                                    color: AppTheme.textPrimary
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AppTheme.primaryPurple),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        booking.pickupLocation,
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Rental Period', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(
                                '${dateFormat.format(booking.startDate)} - ${dateFormat.format(booking.endDate)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Total Paid', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(
                                'Rs $formattedTotal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900, 
                                  fontSize: 16, 
                                  color: AppTheme.primaryPurple
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
