import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = context.watch<DataProvider>().myAllReservations;

    return Scaffold(
      appBar: AppBar(title: const Text('My Reservation History')),
      body: reservations.isEmpty
          ? const Center(child: Text('You haven\'t made any reservations yet.'))
          : ListView.builder(
              itemCount: reservations.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final res = reservations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(res.status),
                      child: const Icon(Icons.event_seat, color: Colors.white, size: 20),
                    ),
                    title: Text(res.seat?.seatNumber ?? 'Seat Reserved'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat('dd MMM yyyy').format(res.reservationDate)}'),
                        Text('Time: ${DateFormat('hh:mm a').format(res.reservedAt)}'),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(res.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        res.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(res.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'fined':
        return Colors.purple;
      case 'cancelled':
        return Colors.grey;
      case 'reserved':
      default:
        return AppTheme.primaryColor;
    }
  }
}
