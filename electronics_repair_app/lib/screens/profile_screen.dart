import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technician Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Admin Technician', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Shop Owner / Manager', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.email, color: AppTheme.secondaryColor),
              title: const Text('Email'),
              subtitle: const Text('admin@techfixpro.com'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: AppTheme.secondaryColor),
              title: const Text('Phone'),
              subtitle: const Text('+1 234 567 890'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
