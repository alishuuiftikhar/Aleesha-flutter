import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.secondary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aleesha Developer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'aleesha@campus.edu',
              style: TextStyle(color: AppColors.secondary),
            ),
            const SizedBox(height: 32),
            _buildStats(context),
            const SizedBox(height: 32),
            _buildProfileMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final reportsCount = provider.items.where((i) => i.reporterId == provider.currentUserId).length;
        final claimsCount = provider.claims.where((c) => c.claimantId == provider.currentUserId).length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statItem('Reports', reportsCount.toString()),
            _statItem('Claims', claimsCount.toString()),
            _statItem('Saved', provider.favoriteIds.length.toString()),
          ],
        );
      },
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: const TextStyle(color: AppColors.secondary)),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        _menuTile(Icons.notifications_outlined, 'Notifications', () {}),
        _menuTile(Icons.security_outlined, 'Privacy & Security', () {}),
        _menuTile(Icons.help_outline, 'Help & Support', () {}),
        _menuTile(Icons.info_outline, 'About Campus Lost & Found', () {}),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.error),
          title: const Text('Logout', style: TextStyle(color: AppColors.error)),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _menuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
