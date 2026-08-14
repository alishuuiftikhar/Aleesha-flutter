import 'package:flutter/material.dart';
import 'theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            index == 0 ? 'Upcoming Event' : 'New Event Near You',
            index == 0 
              ? 'Your ticket for Neon Summer Festival is ready!' 
              : 'Tech Innovators Summit is happening this weekend.',
            '${index + 1}h ago',
            index == 0,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, bool isNew) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isNew ? Border.all(color: AppTheme.primaryColor.withOpacity(0.1)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNew ? AppTheme.primaryColor : AppTheme.textLightColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNew ? Icons.notifications_active : Icons.notifications,
              color: isNew ? Colors.white : AppTheme.textLightColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: AppTheme.textLightColor, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: AppTheme.textLightColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
