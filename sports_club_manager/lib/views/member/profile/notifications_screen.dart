import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text(
              index == 0 ? 'Welcome to the Club!' : 'Class Reminder: HIIT Training',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              index == 0 
                ? 'Thank you for joining our sports community. Explore our facilities today!'
                : 'Your HIIT Training class starts in 1 hour. Don\'t forget your water bottle!',
            ),
            trailing: const Text('2h ago', style: TextStyle(fontSize: 10, color: Colors.grey)),
          );
        },
      ),
    );
  }
}
