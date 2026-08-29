import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Traveler Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('traveler@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _profileOption(Icons.edit, 'Edit Profile'),
            _profileOption(Icons.notifications, 'Notifications'),
            _profileOption(Icons.payment, 'Payment Methods'),
            _profileOption(Icons.help, 'Help & Support'),
            const SizedBox(height: 20),
            _profileOption(Icons.logout, 'Logout', color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
