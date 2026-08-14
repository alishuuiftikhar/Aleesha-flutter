import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 16),
            _buildSettingTile(
              'Push Notifications',
              'Receive updates about your profile',
              Icons.notifications_outlined,
              trailing: Switch.adaptive(
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              'Dark Mode',
              'Toggle between light and dark themes',
              Icons.dark_mode_outlined,
              trailing: Switch.adaptive(
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Account'),
            const SizedBox(height: 16),
            _buildSettingTile(
              'Privacy Settings',
              'Manage who can see your activity',
              Icons.lock_outline,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              'Linked Accounts',
              'Behance, Dribbble, GitHub',
              Icons.link,
              onTap: () {},
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Support'),
            const SizedBox(height: 16),
            _buildSettingTile(
              'Help Center',
              'Get help with your account',
              Icons.help_outline,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              'Terms of Service',
              'Read our legal terms',
              Icons.description_outlined,
              onTap: () {},
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
