import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme (Coming soon)'),
            value: false,
            onChanged: (val) {},
            activeThumbColor: AppTheme.primary,
          ),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('New Artwork Alerts'),
            value: true,
            onChanged: (val) {},
            activeThumbColor: AppTheme.primary,
          ),
          _buildSectionHeader('Account'),
          ListTile(
            title: const Text('Clear Favorites'),
            trailing: const Icon(Icons.delete_outline, color: Colors.red),
            onTap: () {
              // Add clear logic if needed
            },
          ),
          _buildSectionHeader('About'),
          const ListTile(
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
