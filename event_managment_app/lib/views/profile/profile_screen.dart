import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_service.dart';
import '../splash_screen.dart';
import 'organizer_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final supabaseService = Provider.of<SupabaseService>(context, listen: false);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
            ),
            const SizedBox(height: 16),
            Text(
              user?.userMetadata?['full_name'] ?? 'User Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.person_outline, 'Edit Profile', () {}),
            _buildProfileItem(Icons.notifications_none, 'Notifications', () {}),
            _buildProfileItem(Icons.favorite_border, 'Favorites', () {}),
            _buildProfileItem(Icons.settings_outlined, 'Settings', () {}),
            _buildProfileItem(Icons.help_outline, 'Help & Support', () {}),
            const SizedBox(height: 16),
            if (user != null)
              FutureBuilder(
                future: supabaseService.getOrganizer(user.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return _buildProfileItem(
                      Icons.dashboard_outlined,
                      'Organizer Dashboard',
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OrganizerDashboardScreen()),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SplashScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
