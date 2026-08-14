import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EventBookingsScreen extends StatelessWidget {
  const EventBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Bookings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text('AS', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Aleesha Smith', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                      const Text('aleesha.smith@example.com', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.success.withAlpha(25), borderRadius: BorderRadius.circular(4)),
                        child: const Text('PAID', style: TextStyle(color: AppTheme.success, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('VIP x 2', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                    const Text('\$99.98', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    Text('BK${1000 + index}', style: const TextStyle(color: AppTheme.secondaryText, fontSize: 10)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
