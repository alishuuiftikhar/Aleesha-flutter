import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppTheme.secondaryBackground,
                child: const Icon(Icons.person, size: 60, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aleesha Fashionista',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Style Level: Elite',
              style: TextStyle(color: AppTheme.secondary, letterSpacing: 1.2),
            ),
            const SizedBox(height: 40),
            _buildProfileStats(),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.shopping_bag_outlined, 'My Orders'),
            _buildProfileItem(Icons.style_outlined, 'My Style Profile'),
            _buildProfileItem(Icons.straighten, 'Size Measurements'),
            _buildProfileItem(Icons.help_outline, 'Help & Support'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              child: const Text('EDIT PROFILE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('12', 'Looks Saved'),
          _buildStatItem('5', 'Collections'),
          _buildStatItem('Elite', 'Rank'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
