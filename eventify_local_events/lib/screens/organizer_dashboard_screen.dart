import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'manage_events_screen.dart';
import 'event_bookings_screen.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizer Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Events', '12', Icons.event, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Total Sold', '458', Icons.confirmation_num, Colors.orange)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Revenue', '\$12,450', Icons.attach_money, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Avg. Rating', '4.8', Icons.star, Colors.purple)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Recent Bookings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
            const SizedBox(height: 16),
            _buildBookingItem('Aleesha Smith', 'Neon Summer Festival', '\$49.99', '2 mins ago'),
            _buildBookingItem('John Doe', 'Tech Innovators Summit', '\$199.00', '15 mins ago'),
            _buildBookingItem('Sarah Wilson', 'Global Jazz Night', '\$35.00', '1 hour ago'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageEventsScreen())),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Manage All Events'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventBookingsScreen())),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('View All Bookings', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withAlpha(25), child: Icon(icon, color: color)),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
          Text(title, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBookingItem(String user, String event, String price, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppTheme.primaryColor.withAlpha(25), child: const Icon(Icons.person, color: AppTheme.primaryColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                Text(event, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              Text(time, style: const TextStyle(color: AppTheme.secondaryText, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
