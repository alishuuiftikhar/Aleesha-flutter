import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';
import '../auth/dual_login_screen.dart';
import 'seeker_edit_profile_screen.dart';
import 'seeker_resume_screen.dart';
import 'seeker_settings_screen.dart';
import 'seeker_help_screen.dart';

class SeekerProfileScreen extends StatefulWidget {
  const SeekerProfileScreen({super.key});

  @override
  State<SeekerProfileScreen> createState() => _SeekerProfileScreenState();
}

class _SeekerProfileScreenState extends State<SeekerProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final profile = await SupabaseService.getProfile(user.id);
        setState(() => _profile = profile);
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await SupabaseService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToEmployerLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DualLoginScreen(targetRole: 'employer')),
    );
  }

  void _navigateToEditProfile() async {
    if (_profile == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SeekerEditProfileScreen(profile: _profile!)),
    );
    if (result == true) _loadProfile();
  }

  void _navigateToResume() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeekerResumeScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeekerSettingsScreen()),
    );
  }

  void _navigateToHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeekerHelpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppConstants.secondaryBackground,
                    child: Icon(Icons.person, size: 50, color: AppConstants.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profile?['full_name'] ?? 'User Name',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    SupabaseService.client.auth.currentUser?.email ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  _buildProfileCard(
                    title: 'Portal Switch',
                    children: [
                      _buildProfileItem(
                        Icons.business_center,
                        'Login/Register as Employer',
                        'Access hiring tools and post jobs',
                        _navigateToEmployerLogin,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProfileCard(
                    title: 'Account Settings',
                    children: [
                      _buildProfileItem(Icons.person_outline, 'Edit Profile', 'Change your basic information', _navigateToEditProfile),
                      _buildProfileItem(Icons.description_outlined, 'My Resume', 'Update your professional CV', _navigateToResume),
                      _buildProfileItem(Icons.settings_outlined, 'Settings', 'Privacy and security', _navigateToSettings),
                      _buildProfileItem(Icons.help_outline, 'Help Center', 'FAQs and contact support', _navigateToHelp),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppConstants.secondaryBackground, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppConstants.primaryColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
