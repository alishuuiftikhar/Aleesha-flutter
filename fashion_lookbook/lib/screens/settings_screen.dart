import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: ListView(
        children: [
          _buildSettingsHeader('Account'),
          _buildSettingsTile('Personal Information'),
          _buildSettingsTile('Password & Security'),
          _buildSettingsHeader('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Get alerts for new looks'),
            value: true,
            onChanged: (val) {},
            activeColor: AppTheme.primary,
          ),
          SwitchListTile(
            title: const Text('Email Updates'),
            value: false,
            onChanged: (val) {},
            activeColor: AppTheme.primary,
          ),
          _buildSettingsHeader('App Settings'),
          _buildSettingsTile('Language'),
          _buildSettingsTile('Currency'),
          _buildSettingsTile('Theme Personalization'),
          _buildSettingsHeader('About'),
          _buildSettingsTile('Terms of Service'),
          _buildSettingsTile('Privacy Policy'),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {},
            child: const Text('LOGOUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
