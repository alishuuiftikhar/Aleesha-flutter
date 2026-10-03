import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection('General'),
          _buildSwitchTile('Sound Effects', true),
          _buildSwitchTile('Music', false),
          _buildSwitchTile('Haptic Feedback', true),
          _buildSection('Notifications'),
          _buildSwitchTile('Daily Reminders', true),
          _buildSection('Account'),
          ListTile(
            title: const Text('Clear Game History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Reset All Progress'),
            textColor: AppColors.error,
            trailing: const Icon(Icons.chevron_right, color: AppColors.error),
            onTap: () {},
          ),
          _buildSection('About'),
          const ListTile(
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (val) {},
      activeColor: AppColors.primary,
    );
  }
}
