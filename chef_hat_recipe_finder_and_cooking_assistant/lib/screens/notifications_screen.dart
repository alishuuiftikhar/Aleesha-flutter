import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {'title': 'New Recipe Alert!', 'body': 'Try the new Spicy Thai Basil Chicken added today.', 'time': '2h ago'},
      {'title': 'Cooking Tip', 'body': 'Always rest your meat for 5 minutes after grilling.', 'time': '5h ago'},
      {'title': 'Weekly Challenge', 'body': 'Cook 3 healthy meals this week to earn a badge!', 'time': '1d ago'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('No new notifications'))
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: Text(notifications[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notifications[index]['body']!),
                  trailing: Text(notifications[index]['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
