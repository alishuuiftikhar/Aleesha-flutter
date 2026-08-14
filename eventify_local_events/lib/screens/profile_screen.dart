import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/user_provider.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'organizer_dashboard_screen.dart';
import 'tickets_screen.dart';
import 'favorites_screen.dart';
import 'booking_history_screen.dart';
import 'payment_methods_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          _buildHeader(context, user),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatSection(),
                    const SizedBox(height: 24),
                    _buildMenuButton(Icons.confirmation_num_rounded, 'My Tickets', 'View your digital tickets', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketsScreen()));
                    }),
                    _buildMenuButton(Icons.history_rounded, 'Booking History', 'View your past bookings', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingHistoryScreen()));
                    }),
                    _buildMenuButton(Icons.favorite_rounded, 'Favorites', 'Events you have saved', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                    }),
                    _buildMenuButton(Icons.dashboard_rounded, 'Organizer Dashboard', 'Manage your events', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const OrganizerDashboardScreen()));
                    }),
                    _buildMenuButton(Icons.payment_rounded, 'Payment Methods', 'Manage your cards', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
                    }),
                    _buildMenuButton(Icons.settings_rounded, 'Settings', 'Security and privacy', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                    }),
                    _buildMenuButton(Icons.help_center_rounded, 'Help & Support', 'FAQ and contact us', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                    }),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.favorite.withAlpha(25),
                        foregroundColor: AppTheme.favorite,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProvider user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ],
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImage),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: AppTheme.primaryColor),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStatSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('8', 'Attended'),
        Container(width: 1, height: 30, color: AppTheme.secondaryText.withAlpha(50)),
        _buildStatItem('3', 'Upcoming'),
        Container(width: 1, height: 30, color: AppTheme.secondaryText.withAlpha(50)),
        _buildStatItem('12', 'Following'),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withAlpha(20), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppTheme.primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
              ]),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryText, size: 20),
          ],
        ),
      ),
    );
  }
}
