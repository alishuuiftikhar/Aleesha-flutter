import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSettingItem(Icons.notifications_none, 'Notifications', true),
          _buildSettingItem(Icons.dark_mode_outlined, 'Dark Mode', false),
          _buildSettingItem(Icons.language, 'Language', 'English (US)'),
          const SizedBox(height: 32),
          _buildSectionHeader('Security'),
          _buildSettingItem(Icons.lock_outline, 'Privacy Policy', null),
          _buildSettingItem(Icons.description_outlined, 'Terms & Conditions', null),
          const SizedBox(height: 32),
          _buildSectionHeader('About'),
          _buildSettingItem(Icons.info_outline, 'About Eventify', 'Version 1.0.0'),
          _buildSettingItem(Icons.help_outline, 'Help & Support', null),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor.withAlpha(25),
              foregroundColor: AppTheme.secondaryColor,
              elevation: 0,
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, dynamic trailing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryText),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryText),
            ),
          ),
          if (trailing is bool)
            Switch(
              value: trailing,
              onChanged: (v) {},
              activeTrackColor: AppTheme.primaryColor,
            )
          else if (trailing is String)
            Text(trailing, style: const TextStyle(color: AppTheme.secondaryText))
          else
            const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
        ],
      ),
    );
  }
}
