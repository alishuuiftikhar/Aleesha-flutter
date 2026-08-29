import 'package:flutter/material.dart';
import '../../theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 30),
          _buildSection('Account'),
          _buildTile(Icons.person_outline, 'Profile', () {}),
          _buildTile(Icons.notifications_none, 'Notifications', () {}),
          const SizedBox(height: 20),
          _buildSection('App Settings'),
          _buildTile(Icons.palette_outlined, 'Appearance', () {}),
          _buildTile(Icons.language, 'Language', () {}),
          _buildTile(Icons.storage, 'Data & Storage', () {}),
          const SizedBox(height: 20),
          _buildSection('About'),
          _buildTile(Icons.info_outline, 'Privacy Policy', () {}),
          _buildTile(Icons.help_outline, 'Help & Support', () {}),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Hibit Tracker v1.0.0',
              style: TextStyle(color: AppColors.text.withOpacity(0.5), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.text),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
