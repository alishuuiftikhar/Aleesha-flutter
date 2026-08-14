import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().userProfile;
      if (user != null) {
        context.read<DataProvider>().fetchNotifications(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final notifications = data.notifications;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final note = notifications[index];
                return ListTile(
                  leading: Icon(
                    note.isRead ? Icons.notifications_none : Icons.notifications_active,
                    color: note.isRead ? Colors.grey : AppTheme.accentColor,
                  ),
                  title: Text(note.title, style: TextStyle(fontWeight: note.isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(note.message),
                  trailing: Text(DateFormat('hh:mm a').format(note.createdAt), style: const TextStyle(fontSize: 10)),
                  onTap: () {
                    if (!note.isRead) {
                      data.markAsRead(note.id);
                    }
                  },
                );
              },
            ),
    );
  }
}
