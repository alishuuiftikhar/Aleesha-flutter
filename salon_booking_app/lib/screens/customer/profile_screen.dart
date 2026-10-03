import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/auth_notifier.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authProvider).profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.luxuryGradient),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: profile?.avatarUrl != null
                            ? ClipOval(child: Image.network(profile!.avatarUrl!, fit: BoxFit.cover, width: 80, height: 80))
                            : const Icon(Icons.person, size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile?.fullName ?? 'Glamora Guest',
                        style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        profile?.email ?? '',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Loyalty Points Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Glam Points ✨', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
                            const Text('👑 VIP Member', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('1,250', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            const SizedBox(width: 8),
                            const Text('available pts', style: TextStyle(color: AppColors.secondaryText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _profileOption(Icons.person_outline, 'Edit Profile'),
                  _profileOption(Icons.stars_outlined, 'My Loyalty Rewards'),
                  _profileOption(Icons.notifications_none, 'Notifications'),
                  _profileOption(Icons.security, 'Security & Password'),
                  _profileOption(Icons.help_outline, 'Help & Support'),
                  const Divider(height: 40),
                  _profileOption(
                    Icons.logout, 
                    'Sign Out', 
                    color: AppColors.error,
                    onTap: () async {
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (color ?? AppColors.primary).withOpacity(0.05), shape: BoxShape.circle),
        child: Icon(icon, color: color ?? AppColors.primary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color ?? AppColors.mainText)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondaryText),
      contentPadding: EdgeInsets.zero,
    );
  }
}
