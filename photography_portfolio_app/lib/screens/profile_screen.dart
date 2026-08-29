import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final photographer = provider.data!.photographer;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.secondaryBackground,
                  backgroundImage: NetworkImage(photographer.profileImage),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Fallback handled by child
                  },
                  child: photographer.profileImage.isEmpty 
                      ? const Icon(Icons.person, size: 60) 
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  photographer.name,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Fine Art Photographer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor),
                ),
                const SizedBox(height: 32),
                _buildProfileItem(context, Icons.email_outlined, 'Email', photographer.contact['email']!),
                _buildProfileItem(context, Icons.phone_outlined, 'Phone', photographer.contact['phone']!),
                _buildProfileItem(context, Icons.camera_alt_outlined, 'Instagram', photographer.contact['instagram']!),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: AppTheme.textColor),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppTheme.textColor),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppTheme.textColor),
                  title: const Text('About App'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.secondaryColor)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
