import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/booking_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class TicketDetailScreen extends StatelessWidget {
  final Booking booking;
  const TicketDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Digital Ticket', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: Image.network(booking.event.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(booking.event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryText), textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTicketInfo('Date', DateFormat('dd MMM, yyyy').format(booking.event.date)),
                          _buildTicketInfo('Time', booking.event.time.split('-')[0].trim()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTicketInfo('Venue', booking.event.location, crossAlign: CrossAxisAlignment.center),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTicketInfo('Passenger', 'Aleesha Smith'),
                          _buildTicketInfo('Seat', 'VIP-0${booking.id.substring(booking.id.length - 1)}'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const Expanded(child: Divider(thickness: 2, color: AppTheme.backgroundColor)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('SCAN ME', style: TextStyle(color: AppTheme.secondaryText, fontSize: 10, letterSpacing: 2))),
                          const Expanded(child: Divider(thickness: 2, color: AppTheme.backgroundColor)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      QrImageView(data: booking.id, version: QrVersions.auto, size: 180),
                      const SizedBox(height: 16),
                      Text(booking.id, style: const TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, color: AppTheme.secondaryText)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryColor, elevation: 0),
                          child: const Text('Download PDF'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Share Ticket'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value, {CrossAxisAlignment crossAlign = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
      ],
    );
  }
}
