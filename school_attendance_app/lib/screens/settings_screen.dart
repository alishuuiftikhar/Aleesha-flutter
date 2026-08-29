import 'package:flutter/material.dart';
import 'package:school_attendance_app/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'School Administrator',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('admin@school.edu', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSettingItem(Icons.school, 'School Information', 'Name, Address, Contact'),
          _buildSettingItem(Icons.notifications, 'Notifications', 'Attendance alerts, Reminders'),
          _buildSettingItem(Icons.security, 'Security', 'Change Password, Biometrics'),
          _buildSettingItem(Icons.help, 'Help & Support', 'FAQ, Contact Us'),
          const Divider(),
          _buildSettingItem(Icons.logout, 'Logout', 'Exit application', color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primary),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
