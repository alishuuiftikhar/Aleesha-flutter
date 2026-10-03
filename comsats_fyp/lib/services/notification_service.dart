import '../models/notification_model.dart';
import 'mock_data_service.dart';

class NotificationService {
  Future<List<AppNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<AppNotification>.from(MockDataService.instance.notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markAsRead(String id) async {
    final n = MockDataService.instance.notifications.firstWhere((n) => n.id == id);
    n.isRead = true;
  }

  Future<void> markAllAsRead() async {
    for (final n in MockDataService.instance.notifications) {
      n.isRead = true;
    }
  }
}
