import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'admin/admin_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: () async {
              await authService.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: authService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = snapshot.data;
          if (profile == null) return const Center(child: Text('Error loading profile'));

          if (!_isEditing) _nameController.text = profile['full_name'] ?? '';
          final bool isAdmin = profile['role'] == 'admin';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 80, color: AppColors.mainBackground),
                ),
                const SizedBox(height: 24),
                if (_isEditing)
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  )
                else
                  Text(
                    profile['full_name'] ?? 'User Name',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8),
                Text(profile['email'] ?? '', style: const TextStyle(color: AppColors.secondaryText)),
                const SizedBox(height: 32),
                const Divider(color: AppColors.secondaryBackground),
                const SizedBox(height: 16),
                if (isAdmin)
                  _profileMenuItem(
                    Icons.admin_panel_settings_rounded,
                    'Admin Panel',
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard())),
                  ),
                _profileMenuItem(Icons.history, 'Booking History', () {}),
                _profileMenuItem(Icons.payment, 'Payment Methods', () {}),
                _profileMenuItem(Icons.settings, 'Settings', () {}),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () async {
                    if (_isEditing) {
                      await authService.updateProfile(_nameController.text);
                      setState(() => _isEditing = false);
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: Text(_isEditing ? 'SAVE CHANGES' : 'EDIT PROFILE'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _profileMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
      onTap: onTap,
    );
  }
}
