import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../models/booking.dart';
import '../../models/event.dart';

class EventBookingsScreen extends StatelessWidget {
  final Event event;

  const EventBookingsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookings: ${event.title}')),
      body: FutureBuilder<List<Booking>>(
        future: Provider.of<SupabaseService>(context, listen: false).getEventBookings(event.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings yet'));
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('User ID: ${booking.userId}'),
                subtitle: Text('Quantity: ${booking.quantity} | Total: \$${booking.totalPrice}'),
                trailing: Text(booking.status),
              );
            },
          );
        },
      ),
    );
  }
}
