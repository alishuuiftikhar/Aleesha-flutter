import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/booking_model.dart';
import '../theme/app_theme.dart';
import 'main_container.dart';
import 'ticket_detail_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;
  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.check_circle, color: AppTheme.success, size: 100),
              const SizedBox(height: 24),
              const Text('Booking Confirmed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
              const Text('Your ticket has been booked successfully.', style: TextStyle(color: AppTheme.secondaryText)),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20)]),
                child: Column(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(booking.event.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover)),
                    const SizedBox(height: 16),
                    Text(booking.event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryText)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetail('Booking ID', booking.id),
                        _buildDetail('Quantity', '${booking.quantity} Tickets'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetail('Total Paid', '\$${booking.totalAmount.toStringAsFixed(2)}'),
                        _buildDetail('Ticket Type', booking.ticketType.name.toUpperCase()),
                      ],
                    ),
                    const Divider(height: 40),
                    QrImageView(data: booking.id, version: QrVersions.auto, size: 150),
                    const SizedBox(height: 8),
                    const Text('Show this QR at the entrance', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailScreen(booking: booking))),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('View Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainContainer()), (route) => false),
                child: const Text('Back to Home', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
      ],
    );
  }
}
