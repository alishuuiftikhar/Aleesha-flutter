import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';
import '../auth/dual_login_screen.dart';
import 'company_details_screen.dart';
import 'job_analytics_screen.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  bool _isLoading = false;

  Future<void> _logout() async {
    await SupabaseService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToSeekerLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DualLoginScreen(targetRole: 'seeker')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employer Profile')),
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
                    child: Icon(Icons.business, size: 50, color: AppConstants.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Company Admin',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  _buildProfileCard(
                    title: 'Portal Switch',
                    children: [
                      _buildProfileItem(
                        Icons.person_search,
                        'Login/Register as Seeker',
                        'Find jobs and manage applications',
                        _navigateToSeekerLogin,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProfileCard(
                    title: 'Hiring Management',
                    children: [
                      _buildProfileItem(
                        Icons.edit_note, 
                        'Company Details', 
                        'Update your business profile', 
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CompanyDetailsScreen())),
                      ),
                      _buildProfileItem(
                        Icons.analytics_outlined, 
                        'Job Analytics', 
                        'Track your postings performance', 
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JobAnalyticsScreen())),
                      ),
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
