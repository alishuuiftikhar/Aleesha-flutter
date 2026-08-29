import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: TravelTheme.accent,
              child: Icon(Icons.person, size: 60, color: TravelTheme.bgMain),
            ),
            const SizedBox(height: 15),
            const Text(
              'Aleesha Explorer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
            ),
            const Text(
              'aleesha@travelapp.com',
              style: TextStyle(color: TravelTheme.textSecondary),
            ),
            const SizedBox(height: 30),
            _buildSettingTile(Icons.person_outline, 'Edit Profile'),
            _buildSettingTile(Icons.notifications_none, 'Notifications'),
            _buildSettingTile(Icons.payment, 'Payment Methods'),
            _buildSettingTile(Icons.security, 'Security'),
            _buildSettingTile(Icons.help_outline, 'Help & Support'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: TravelTheme.secondary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Logout', style: TextStyle(color: TravelTheme.bgMain, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: TravelTheme.bgSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: TravelTheme.primary),
        title: Text(title, style: const TextStyle(color: TravelTheme.textMain)),
        trailing: const Icon(Icons.arrow_forward_ios, color: TravelTheme.textSecondary, size: 16),
        onTap: () {},
      ),
    );
  }
}
