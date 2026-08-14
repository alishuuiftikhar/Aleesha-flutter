import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../theme/app_theme.dart';
import 'ticket_detail_screen.dart';
import 'package:intl/intl.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Upcoming'), Tab(text: 'Past')],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.secondaryText,
            indicatorColor: AppTheme.primaryColor,
          ),
        ),
        body: const TabBarView(
          children: [TicketListView(isUpcoming: true), TicketListView(isUpcoming: false)],
        ),
      ),
    );
  }
}

class TicketListView extends StatelessWidget {
  final bool isUpcoming;
  const TicketListView({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final bookings = isUpcoming ? context.watch<BookingProvider>().upcomingBookings : context.watch<BookingProvider>().pastBookings;

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_num_outlined, size: 80, color: AppTheme.secondaryText.withAlpha(51)),
            const SizedBox(height: 16),
            Text('No ${isUpcoming ? 'upcoming' : 'past'} tickets found', style: const TextStyle(color: AppTheme.secondaryText)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketDetailScreen(booking: booking))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 5))]),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(booking.event.imageUrl, width: 80, height: 80, fit: BoxFit.cover)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(DateFormat('dd MMM, yyyy').format(booking.event.date), style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: AppTheme.secondaryText),
                          const SizedBox(width: 4),
                          Expanded(child: Text(booking.event.location, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
              ],
            ),
          ),
        );
      },
    );
  }
}
