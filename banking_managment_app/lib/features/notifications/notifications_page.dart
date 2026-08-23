import 'package:flutter/material.dart';
import '../../core/constants.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a simulated notifications page
    final notifications = [
      {
        'title': 'Login Alert',
        'desc': 'New login detected on your account from a new device.',
        'time': '2h ago',
        'icon': Icons.security,
      },
      {
        'title': 'Transfer Successful',
        'desc': 'Your transfer of \$500.00 to John Doe was successful.',
        'time': '1d ago',
        'icon': Icons.check_circle_outline,
      },
      {
        'title': 'System Update',
        'desc': 'Emerald Banking has been updated to version 2.0.',
        'time': '3d ago',
        'icon': Icons.system_update,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final note = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary.withOpacity(0.3),
                child: Icon(note['icon'] as IconData, color: AppColors.primary),
              ),
              title: Text(note['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(note['desc'] as String, style: const TextStyle(color: AppColors.secondaryText)),
                  const SizedBox(height: 4),
                  Text(note['time'] as String, style: const TextStyle(fontSize: 10, color: AppColors.accent)),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
