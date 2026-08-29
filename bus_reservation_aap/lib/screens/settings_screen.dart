import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (val) {},
            activeColor: AppColors.secondary,
          ),
          SwitchListTile(
            title: const Text('Dark Mode (System)'),
            value: false,
            onChanged: (val) {},
            activeColor: AppColors.secondary,
          ),
          ListTile(
            title: const Text('Language'),
            trailing: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Currency'),
            trailing: const Text('USD (\$)'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('About App'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
