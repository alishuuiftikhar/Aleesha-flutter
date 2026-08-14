import 'package:flutter/material.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts for new recipes and tips'),
            value: _appState.notificationsEnabled,
            onChanged: (val) => setState(() => _appState.notificationsEnabled = val),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Easier on the eyes at night'),
            value: _appState.darkModeEnabled,
            onChanged: (val) => setState(() => _appState.darkModeEnabled = val),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('App Version'),
            trailing: const Text('2.0.0'),
          ),
        ],
      ),
    );
  }
}
