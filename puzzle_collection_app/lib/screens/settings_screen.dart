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
        padding: const EdgeInsets.all(16),
        children: [
          _settingsTile(
            context,
            'Sound Effects',
            'Enable or disable game sounds',
            Icons.volume_up,
            true,
          ),
          _settingsTile(
            context,
            'Notifications',
            'Get daily puzzle reminders',
            Icons.notifications,
            false,
          ),
          _settingsTile(
            context,
            'Dark Mode',
            'Switch to dark theme',
            Icons.dark_mode,
            false,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Reset All Progress'),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, String title, String subtitle, IconData icon, bool initialValue) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: initialValue,
        onChanged: (value) {},
        activeColor: AppColors.primary,
      ),
    );
  }
}
