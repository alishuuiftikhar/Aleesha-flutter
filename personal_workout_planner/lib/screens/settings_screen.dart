import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          _buildSection('Account'),
          _buildSettingItem('Edit Profile', Icons.person_outline),
          _buildSettingItem('Change Password', Icons.lock_outline),
          const SizedBox(height: 24),
          _buildSection('Notifications'),
          _buildSwitchItem('Workout Reminders', true),
          _buildSwitchItem('New Challenges', false),
          const SizedBox(height: 24),
          _buildSection('Preferences'),
          _buildSettingItem('Language', Icons.language, trailing: 'English'),
          _buildSettingItem('Units', Icons.straighten, trailing: 'Metric'),
          const SizedBox(height: 24),
          _buildSection('App'),
          _buildSettingItem('About Us', Icons.info_outline),
          _buildSettingItem('Privacy Policy', Icons.security),
          _buildSettingItem('Terms of Service', Icons.description),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryText),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) Text(trailing, style: const TextStyle(color: AppColors.secondaryText)),
          const Icon(Icons.chevron_right, color: AppColors.secondaryText),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildSwitchItem(String title, bool value) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (val) {},
        activeColor: AppColors.primary,
      ),
    );
  }
}
