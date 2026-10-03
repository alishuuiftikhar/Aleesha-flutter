import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/profile_model.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      if (user != null) {
        final profile = await service.getProfile(user.id);
        if (mounted) {
          setState(() {
            _profile = profile;
            _isLoading = false;
          });
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Profile Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  void _logout() async {
    await context.read<SupabaseService>().signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _switchRole() async {
    if (_profile == null) return;
    
    final newRole = _profile!.role == 'student' ? 'tutor' : 'student';
    
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      // 1. Update the role in the database first
      await service.updateUserRole(_profile!.id, newRole);
      
      // 2. Log out so they must re-authenticate
      await service.signOut();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated to $newRole. Please login to continue.'),
            backgroundColor: AppColors.primary,
          ),
        );
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update role: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profile?.avatarUrl != null ? NetworkImage(_profile!.avatarUrl!) : null,
              child: _profile?.avatarUrl == null ? const Icon(Icons.person, size: 60) : null,
            ),
            const SizedBox(height: 16),
            Text(
              _profile?.fullName ?? 'User Name',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(_profile?.email ?? 'email@example.com'),
            const SizedBox(height: 32),
            _buildProfileOption(Icons.edit, 'Edit Profile', () {}),
            _buildProfileOption(Icons.notifications, 'Notifications', () {}),
            _buildProfileOption(Icons.settings, 'Settings', () {}),
            _buildProfileOption(Icons.help_outline, 'Help Support', () {}),
            const SizedBox(height: 16),
            Card(
              color: AppColors.secondaryBackground,
              child: ListTile(
                leading: Icon(
                  _profile?.role == 'student' ? Icons.school : Icons.person_search,
                  color: AppColors.primary,
                ),
                title: Text(
                  _profile?.role == 'student' ? 'Switch to Tutor Mode' : 'Switch to Student Mode',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _profile?.role == 'student' 
                    ? 'Start teaching and earning' 
                    : 'Find and book tutors for classes',
                ),
                trailing: const Icon(Icons.swap_horiz),
                onTap: _switchRole,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
