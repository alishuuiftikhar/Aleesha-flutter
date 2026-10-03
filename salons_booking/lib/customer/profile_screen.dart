import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final String currentRole;
  const ProfileScreen({super.key, required this.currentRole});

  void _switchRole(BuildContext context, String targetRole) async {
    // Log out first
    await AuthService().signOut();

    if (!context.mounted) return;

    // Navigate to login screen of target role
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(role: targetRole)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightPink,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            if (currentRole == 'customer') _buildLoyaltyCard(),
            const SizedBox(height: 20),
            _buildRoleSwitcher(context),
            const SizedBox(height: 20),
            _buildMenuSection(context),
            const SizedBox(height: 30),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSwitcher(BuildContext context) {
    List<Map<String, dynamic>> otherRoles = [];
    if (currentRole == 'customer') {
      otherRoles = [
        {'role': 'staff', 'label': 'Login as Staff', 'icon': Icons.content_cut},
        {'role': 'admin', 'label': 'Login as Admin', 'icon': Icons.admin_panel_settings},
      ];
    } else if (currentRole == 'staff') {
      otherRoles = [
        {'role': 'customer', 'label': 'Login as Customer', 'icon': Icons.person},
        {'role': 'admin', 'label': 'Login as Admin', 'icon': Icons.admin_panel_settings},
      ];
    } else if (currentRole == 'admin') {
      otherRoles = [
        {'role': 'customer', 'label': 'Login as Customer', 'icon': Icons.person},
        {'role': 'staff', 'label': 'Login as Staff', 'icon': Icons.content_cut},
      ];
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.softRose),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Switch Account ✨',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepRose),
          ),
          const SizedBox(height: 12),
          Row(
            children: otherRoles.map((roleData) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => _switchRole(context, roleData['role']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.veryLightPink,
                      foregroundColor: AppTheme.primaryRosePink,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppTheme.softRose),
                    ),
                    child: Column(
                      children: [
                        Icon(roleData['icon'], size: 20),
                        const SizedBox(height: 4),
                        Text(roleData['role'].toUpperCase(), style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await AuthService().signOut();
            if (!context.mounted) return;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent),
            foregroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Logout Session'),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        color: AppTheme.primaryRosePink,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: AppTheme.primaryRosePink),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aleesha Smith',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'aleesha@example.com',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.deepRose, AppTheme.primaryRosePink],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.deepRose.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Glamora Rewards', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('Glow Starter', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Points: 450', style: TextStyle(color: Colors.white, fontSize: 16)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.deepRose),
                child: const Text('Redeem'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.favorite_border, 'My Favorites', () {}),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.history, 'Booking History', () {}),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.notifications_none, 'Notifications', () {}),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.security, 'Change Password', () {}),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.deepRose),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
