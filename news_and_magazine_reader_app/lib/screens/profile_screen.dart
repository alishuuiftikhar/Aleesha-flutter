import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final supabaseService = SupabaseService();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.highlight,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.background,
                        child: Icon(Icons.person, size: 50, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.email?.split('@')[0].toUpperCase() ?? 'NOVA READER',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      user?.email ?? 'guest@novanews.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('ACTIVITY'),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    Icons.history_rounded, 
                    'Reading History', 
                    'Track your recently viewed stories',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
                  ),
                  _buildProfileTile(
                    Icons.bookmark_added_rounded, 
                    'Saved Collections', 
                    'Manage your bookmarked articles',
                    () {}, // This could navigate to the Saved tab
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('PREFERENCES'),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    Icons.notifications_active_outlined, 
                    'Notifications', 
                    'Breaking news and daily digests',
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.visibility_outlined, 
                    'Appearance', 
                    'Customize your reading experience',
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.translate_rounded, 
                    'Language', 
                    'English (US)',
                    () {},
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('ACCOUNT'),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    Icons.shield_outlined, 
                    'Privacy & Security', 
                    'Manage your data and active sessions',
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.help_outline_rounded, 
                    'Help Center', 
                    'FAQ and customer support',
                    () {},
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      await supabaseService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.accent,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.accent, width: 1.5),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'LOGOUT FROM ACCOUNT',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: Text(
                      'NOVA NEWS VERSION 1.0.0',
                      style: TextStyle(
                        color: AppColors.text.withOpacity(0.3),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: AppColors.secondary,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppColors.text.withOpacity(0.5)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondary),
      ),
    );
  }
}
