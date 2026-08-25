import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('App Preferences'),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          const Divider(height: 32),
          _buildSection('Data Management'),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reset Onboarding'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showOnboarding', true);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Onboarding will show on next restart')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: const Text('Clear All Data', style: TextStyle(color: AppColors.error)),
            onTap: () {
              // Implementation for clearing DB would go here
            },
          ),
          const Divider(height: 32),
          _buildSection('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0', style: TextStyle(color: AppColors.secondaryText)),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Developer'),
            trailing: Text('Professional Dev', style: TextStyle(color: AppColors.secondaryText)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
