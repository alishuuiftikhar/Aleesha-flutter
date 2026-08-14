import 'package:flutter/material.dart';
import 'theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingItem(Icons.person_outline, 'Edit Profile', 'Change your name and photo'),
          _buildSettingItem(Icons.email_outlined, 'Email Notifications', 'Manage your email preferences'),
          _buildSettingItem(Icons.lock_outline, 'Privacy', 'Manage your account security'),
          const SizedBox(height: 32),
          _buildSectionHeader('Preferences'),
          _buildSettingItem(Icons.dark_mode_outlined, 'Dark Mode', 'Off', isSwitch: true),
          _buildSettingItem(Icons.language_outlined, 'Language', 'English (US)'),
          _buildSettingItem(Icons.location_on_outlined, 'Location Services', 'Enabled', isSwitch: true),
          const SizedBox(height: 32),
          _buildSectionHeader('More'),
          _buildSettingItem(Icons.info_outline, 'About Eventify', 'Version 1.0.0'),
          _buildSettingItem(Icons.help_outline, 'Help & Support', ''),
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

  Widget _buildSettingItem(IconData icon, String title, String subtitle, {bool isSwitch = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppTheme.textLightColor, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (isSwitch)
            Switch(value: false, onChanged: (v) {}, activeColor: AppTheme.primaryColor)
          else
            const Icon(Icons.chevron_right, color: AppTheme.textLightColor),
        ],
      ),
    );
  }
}
