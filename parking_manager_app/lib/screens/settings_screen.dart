import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('App Settings'),
          _buildSettingItem(Icons.notifications, 'Notifications', true),
          _buildSettingItem(Icons.lock, 'Security', false),
          const SizedBox(height: 20),
          _buildSection('Parking Configuration'),
          _buildSettingItem(Icons.attach_money, 'Hourly Rate (\$5.00)', false),
          _buildSettingItem(Icons.business, 'Lot Information', false),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool hasSwitch) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondary),
        title: Text(title),
        trailing: hasSwitch ? Switch(value: true, onChanged: (v) {}) : const Icon(Icons.chevron_right),
      ),
    );
  }
}
