import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileSection(context, isDark),
          const SizedBox(height: 30),
          _buildSectionHeader("Notifications"),
          _buildSettingTile(Icons.notifications_outlined, "Daily Reminder", "Set a time to meditate", true),
          _buildSettingTile(Icons.volume_up_outlined, "Sound Effects", "Haptic feedback and cues", true),
          const SizedBox(height: 20),
          _buildSectionHeader("Appearance"),
          _buildSettingTile(Icons.dark_mode_outlined, "Dark Mode", "Use sage dark theme", isDark),
          const SizedBox(height: 20),
          _buildSectionHeader("Support"),
          _buildSettingTile(Icons.help_outline, "Help Center", null, null),
          _buildSettingTile(Icons.privacy_tip_outlined, "Privacy Policy", null, null),
          _buildSettingTile(Icons.info_outline, "About SereneMind", "v1.0.0", null),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {},
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.secondaryBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Mindful Soul", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Free Member", style: TextStyle(color: AppColors.secondary)),
            ],
          ),
          Spacer(),
          Icon(Icons.edit_outlined, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String? subtitle, bool? value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: value != null 
          ? Switch(value: value, onChanged: (v) {}, activeColor: AppColors.primary)
          : const Icon(Icons.chevron_right, color: AppColors.secondary),
    );
  }
}
