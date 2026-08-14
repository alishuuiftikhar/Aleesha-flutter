import 'package:flutter/material.dart';
import 'theme.dart';
import 'settings_screen.dart';
import 'my_tickets_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatSection(),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
                        );
                      },
                      child: _buildMenuButton(Icons.confirmation_num_rounded, 'My Tickets', '3 upcoming events'),
                    ),
                    _buildMenuButton(Icons.payment_rounded, 'Payments', 'Manage your cards'),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      child: _buildMenuButton(Icons.settings_rounded, 'Settings', 'Preferences and security'),
                    ),
                    _buildMenuButton(Icons.help_center_rounded, 'Support', 'FAQ and contact us'),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                        foregroundColor: AppTheme.secondaryColor,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&auto=format&fit=crop'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aleesha Smith',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'aleesha.smith@example.com',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('8', 'Attended'),
        Container(width: 1, height: 40, color: AppTheme.textLightColor.withOpacity(0.2)),
        _buildStatItem('3', 'Upcoming'),
        Container(width: 1, height: 40, color: AppTheme.textLightColor.withOpacity(0.2)),
        _buildStatItem('12', 'Following'),
      ],
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLightColor),
        ),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textLightColor),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textLightColor),
        ],
      ),
    );
  }
}
