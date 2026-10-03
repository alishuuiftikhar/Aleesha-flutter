import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact & Help Desk')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Need assistance with the FYP Portal? Reach out through official campus channels or use self-service help.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
              title: const Text('Email Support'),
              subtitle: const Text('${AppConstants.supportEmail}\nResponse within 24 hours'),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.apartment_outlined, color: AppColors.primary),
              title: Text('Coordinator Office'),
              subtitle: Text('Department of Computer Science, Room C-104\nVehari Campus · Mon–Fri 09:00 AM – 04:00 PM'),
            ),
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.lock_reset_outlined, color: AppColors.primary),
              title: Text('Account Assistance'),
              subtitle: Text('Forgotten password, credentials, or 2FA — use Reset Password or contact your coordinator.'),
            ),
          ),
        ],
      ),
    );
  }
}
