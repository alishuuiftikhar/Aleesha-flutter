import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.secondaryBackground,
              child: Icon(Icons.person, size: 50, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            const Text('User Name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('user@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.settings, 'Settings', () {}),
            _buildProfileItem(Icons.notifications, 'Notifications', () {}),
            _buildProfileItem(Icons.security, 'Security', () {}),
            _buildProfileItem(Icons.help, 'Help & Support', () {}),
            _buildProfileItem(Icons.logout, 'Logout', () {}, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primaryColor),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
