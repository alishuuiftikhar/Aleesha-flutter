import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class SeekerSettingsScreen extends StatefulWidget {
  const SeekerSettingsScreen({super.key});

  @override
  State<SeekerSettingsScreen> createState() => _SeekerSettingsScreenState();
}

class _SeekerSettingsScreenState extends State<SeekerSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive job alerts and application updates'),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            activeColor: AppConstants.primaryColor,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            activeColor: AppConstants.primaryColor,
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
