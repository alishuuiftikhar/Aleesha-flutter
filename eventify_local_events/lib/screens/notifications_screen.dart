import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        itemBuilder: (context, index) {
          final titles = ['Booking Confirmed!', 'Upcoming Event', 'New Music Event', 'Payment Successful', 'Event Reminder'];
          final messages = ['Your ticket for Neon Summer Festival is ready.', 'Don\'t forget! Tech Innovators Summit is tomorrow.', 'Check out the new Global Jazz Night happening this weekend.', 'Payment of \$199.00 was successful.', 'VR Gaming Tournament starts in 3 hours. Get ready!'];
          final times = ['2 mins ago', '1 hour ago', '5 hours ago', 'Yesterday', '2 days ago'];
          final icons = [Icons.check_circle, Icons.event, Icons.music_note, Icons.account_balance_wallet, Icons.notifications_active];
          final colors = [Colors.green, Colors.orange, Colors.blue, Colors.purple, Colors.red];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 5))]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundColor: colors[index].withAlpha(25), child: Icon(icons[index], color: colors[index], size: 20)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryText)),
                          Text(times[index], style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(messages[index], style: const TextStyle(color: AppTheme.secondaryText, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
