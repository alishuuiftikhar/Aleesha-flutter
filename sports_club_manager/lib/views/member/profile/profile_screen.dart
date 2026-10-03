import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/supabase_service.dart';
import '../../auth/login_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../admin/dashboard/admin_dashboard.dart';
import '../bookings/booking_history_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = context.read<SupabaseService>();
    final user = supabaseService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await supabaseService.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.secondaryBackground,
              child: Icon(Icons.person, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              user?.email?.split('@')[0].toUpperCase() ?? 'MEMBER',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildProfileItem(context, Icons.person_outline, 'Edit Profile'),
            _buildProfileItem(context, Icons.history, 'Booking History'),
            _buildProfileItem(context, Icons.payment, 'Payment Records'),
            _buildProfileItem(context, Icons.notifications_none, 'Notifications'),
            _buildProfileItem(context, Icons.settings_outlined, 'Settings'),
            _buildProfileItem(context, Icons.help_outline, 'Help & Support'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboard()),
                );
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Admin Panel'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String label) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (label == 'Booking History') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
            );
          } else if (label == 'Notifications') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          } else if (label == 'Settings') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
        },
      ),
    );
  }
}
