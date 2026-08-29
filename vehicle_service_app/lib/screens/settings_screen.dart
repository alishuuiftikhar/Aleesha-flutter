import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondaryBackground,
              child: Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('Aleesha', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('aleesha@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildSettingsItem(Icons.notifications, 'Notifications', 'Enabled'),
            _buildSettingsItem(Icons.language, 'Language', 'English'),
            _buildSettingsItem(Icons.security, 'Privacy & Security', ''),
            _buildSettingsItem(Icons.help_outline, 'Help & Support', ''),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text('App Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String trailing) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
