import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.deadline:
        return Icons.event_outlined;
      case NotificationType.feedback:
        return Icons.feedback_outlined;
      case NotificationType.milestone:
        return Icons.flag_outlined;
      case NotificationType.general:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: notification.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(_icon, color: AppColors.primary, size: 20),
      ),
      title: Text(notification.title,
          style: TextStyle(fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold, fontSize: 14)),
      subtitle: Text(notification.message, style: const TextStyle(fontSize: 12.5)),
      trailing: notification.isRead
          ? null
          : Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
    );
  }
}
