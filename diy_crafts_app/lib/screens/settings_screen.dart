import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode (Coming Soon)'),
            value: false,
            onChanged: (val) {},
            secondary: const Icon(Icons.dark_mode),
          ),
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Project Reminders'),
            value: true,
            onChanged: (val) {},
            secondary: const Icon(Icons.notifications),
          ),
          _buildSectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('Clear All Local Data', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Confirmation dialog and logic
            },
          ),
          _buildSectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('DIY Craft Studio v1.0.0'),
            subtitle: Text('Made with love for creators.'),
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
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
