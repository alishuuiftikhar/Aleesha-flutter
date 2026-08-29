import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/booking_provider.dart';
import 'home_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  final String name;
  final String email;
  final String phone;
  final double totalPrice;

  const BookingSummaryScreen({
    super.key,
    required this.route,
    required this.name,
    required this.email,
    required this.phone,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final selectedSeats = Provider.of<BookingProvider>(context).selectedSeats;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Review & Confirm'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Journey Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 15),
                    _infoRow(Icons.directions_bus, route['busName'], route['busType']),
                    const SizedBox(height: 10),
                    _infoRow(Icons.calendar_today, route['date'], route['departureTime']),
                    const SizedBox(height: 10),
                    _infoRow(Icons.location_on, '${route['departureCity']} → ${route['destinationCity']}', ''),
                    const Divider(height: 30),
                    const Text('Passenger & Seats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 15),
                    _textRow('Name', name),
                    _textRow('Email', email),
                    _textRow('Phone', phone),
                    _textRow('Seats', selectedSeats.join(', ')),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final bookingId = await Provider.of<BookingProvider>(context, listen: false).confirmBooking(
                    routeId: route['id'],
                    name: name,
                    email: email,
                    phone: phone,
                    basePrice: (route['basePrice'] as num).toDouble(),
                  );
                  
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                        content: const Text(
                          'Booking Successful!\nYour tickets have been reserved.',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('GO HOME'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('CONFIRM & PAY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _textRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
