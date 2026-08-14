import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.notifications, color: Color(0xFF2D6A4F)),
              ),
              title: Text('Notification Title ${index + 1}'),
              subtitle: const Text('This is a detail message about your plant care schedule.'),
              trailing: const Text('2h ago', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}
