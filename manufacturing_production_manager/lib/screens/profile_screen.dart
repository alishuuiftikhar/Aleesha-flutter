import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppConstants.secondaryBackground,
              child: Icon(Icons.person, size: 60, color: AppConstants.primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              user?.email ?? 'User Email',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Production Manager', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildProfileItem(context, Icons.settings_outlined, 'Settings', () {}),
            _buildProfileItem(context, Icons.help_outline, 'Help & Support', () {}),
            _buildProfileItem(context, Icons.info_outline, 'About App', () {}),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: AppConstants.errorColor),
                label: const Text('Logout', style: TextStyle(color: AppConstants.errorColor)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppConstants.errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
