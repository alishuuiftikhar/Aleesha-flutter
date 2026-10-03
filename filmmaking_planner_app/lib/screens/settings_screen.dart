import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('SETTINGS', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('PREFERENCES'),
          _buildSettingsTile(context, Icons.dark_mode_outlined, 'Appearance', 'Light (Olive & Sage)'),
          _buildSettingsTile(context, Icons.notifications_outlined, 'Notifications', 'Enabled'),
          const SizedBox(height: 24),
          _buildSectionHeader('DATA'),
          _buildSettingsTile(context, Icons.cloud_upload_outlined, 'Export Data', 'JSON format', onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting to JSON...')));
          }),
          _buildSettingsTile(context, Icons.delete_forever_outlined, 'Clear All Projects', '', isDestructive: true, onTap: () {
            _showClearDialog(context);
          }),
          const SizedBox(height: 24),
          _buildSectionHeader('ABOUT'),
          _buildSettingsTile(context, Icons.info_outline, 'Version', '1.0.0'),
          _buildSettingsTile(context, Icons.policy_outlined, 'Privacy Policy', ''),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This will delete all projects permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).clearAllProjects();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared.')));
            },
            child: const Text('CLEAR ALL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String value, {bool isDestructive = false, VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
        title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : AppColors.text, fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value.isNotEmpty) Text(value, style: TextStyle(color: AppColors.secondary, fontSize: 12)),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.secondary),
          ],
        ),
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title feature coming soon!')));
        },
      ),
    );
  }
}
