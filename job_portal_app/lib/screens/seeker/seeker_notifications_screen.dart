import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class SeekerNotificationsScreen extends StatefulWidget {
  const SeekerNotificationsScreen({super.key});

  @override
  State<SeekerNotificationsScreen> createState() => _SeekerNotificationsScreenState();
}

class _SeekerNotificationsScreenState extends State<SeekerNotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final response = await SupabaseService.client
            .from('notifications')
            .select()
            .eq('user_id', user.id)
            .order('created_at', ascending: false);
        setState(() => _notifications = List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No new notifications.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final note = _notifications[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.notifications)),
                        title: Text(note['title'] ?? 'Notification'),
                        subtitle: Text(note['message'] ?? ''),
                        trailing: Text(
                          note['created_at'] != null 
                              ? note['created_at'].toString().split('T')[0] 
                              : '',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
