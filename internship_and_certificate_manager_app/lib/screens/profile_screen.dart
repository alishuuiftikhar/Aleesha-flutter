import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final student = provider.student;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(context, student),
                const SizedBox(height: 32),
                _buildInfoSection(context, 'Academic Information', [
                  _buildInfoTile(Icons.school, 'University', student?.university ?? 'Not set'),
                  _buildInfoTile(Icons.history_edu, 'Degree', student?.degree ?? 'Not set'),
                  _buildInfoTile(Icons.calendar_view_day, 'Semester', student?.semester ?? 'Not set'),
                ]),
                const SizedBox(height: 24),
                _buildInfoSection(context, 'Contact Information', [
                  _buildInfoTile(Icons.email_outlined, 'Email', student?.email ?? 'Not set'),
                  _buildInfoTile(Icons.phone_outlined, 'Phone', student?.phone ?? 'Not set'),
                ]),
                const SizedBox(height: 24),
                _buildInfoSection(context, 'Account', [
                  ListTile(
                    leading: const Icon(Icons.favorite, color: AppColors.error),
                    title: const Text('Favorites'),
                    subtitle: const Text('View your saved certificates'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSkillsSection(context, student?.skills),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic student) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.cardBackground,
          backgroundImage: student?.profileImage != null ? FileImage(File(student!.profileImage!)) : null,
          child: student?.profileImage == null
              ? const Icon(Icons.person, size: 60, color: AppColors.primary)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          student?.name ?? 'Guest User',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Text(
          student?.degree ?? 'Aspiring Professional',
          style: const TextStyle(color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent)),
        const SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryText, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
    );
  }

  Widget _buildSkillsSection(BuildContext context, String? skills) {
    final skillList = skills?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skills', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent)),
        const SizedBox(height: 12),
        if (skillList.isEmpty)
          const Text('No skills added yet', style: TextStyle(color: AppColors.secondaryText))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skillList.map((skill) => Chip(
              label: Text(skill),
              backgroundColor: AppColors.primary.withOpacity(0.1),
              side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            )).toList(),
          ),
      ],
    );
  }
}
