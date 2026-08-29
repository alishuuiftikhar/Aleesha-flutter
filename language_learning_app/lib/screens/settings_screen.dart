import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants/colors.dart';
import 'language_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Learning"),
          _buildSettingsTile(
            context,
            "Target Language",
            Provider.of<AppProvider>(context).selectedLanguage?.name ?? "Select",
            Icons.language,
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
            ),
          ),
          _buildSettingsTile(
            context,
            "Daily Goal",
            "${Provider.of<AppProvider>(context).dailyGoal} XP",
            Icons.flag,
            () {},
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("Account"),
          _buildSettingsTile(context, "Notifications", "On", Icons.notifications, () {}),
          _buildSettingsTile(context, "Privacy Policy", "", Icons.lock, () {}),
          _buildSettingsTile(context, "Terms of Service", "", Icons.description, () {}),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error.withOpacity(0.1),
              foregroundColor: AppColors.error,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, String value, IconData icon, VoidCallback onTap) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.secondaryBackground),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value.isNotEmpty)
              Text(value, style: const TextStyle(color: AppColors.textLight)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
