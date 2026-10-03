import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondaryBackground,
              child: Icon(Icons.person, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 15),
            const Text(
              'Art Enthusiast',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('collector@museumguide.com', style: TextStyle(color: AppColors.secondary)),
            const SizedBox(height: 30),
            _buildProfileItem(Icons.settings_outlined, 'Settings', () {}),
            _buildProfileItem(Icons.notifications_none, 'Notifications', () {}),
            _buildProfileItem(Icons.help_outline, 'Help & Support', () {}),
            _buildProfileItem(Icons.info_outline, 'About the App', () {}),
            const SizedBox(height: 20),
            const Divider(),
            _buildProfileItem(Icons.logout, 'Logout', () {}, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
