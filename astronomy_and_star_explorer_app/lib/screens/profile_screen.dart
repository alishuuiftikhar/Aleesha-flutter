import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EXPLORER PROFILE')),
      body: Consumer<AstronomyProvider>(
        builder: (context, provider, child) {
          final quizResults = provider.quizResults;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.secondaryBackground,
                  child: Icon(Icons.person, size: 60, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                const Text('Star Voyager', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Rank: Novice Observer', style: TextStyle(color: AppColors.secondary)),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Quiz History'),
                const SizedBox(height: 12),
                if (quizResults.isEmpty)
                  const Text('No quiz attempts yet.', style: TextStyle(color: Colors.white38))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quizResults.length.clamp(0, 5),
                    itemBuilder: (context, index) {
                      final res = quizResults[index];
                      return ListTile(
                        leading: const Icon(Icons.history, color: AppColors.primary),
                        title: Text('${res.difficulty} Quiz'),
                        subtitle: Text(DateFormat('MMM dd, yyyy').format(res.date)),
                        trailing: Text('${res.score}/${res.totalQuestions}', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      );
                    },
                  ),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'Settings'),
                const SizedBox(height: 12),
                _buildSettingsTile(Icons.notifications, 'Notifications', true, (val) {}),
                _buildSettingsTile(Icons.dark_mode, 'Dark Mode', true, null),
                _buildSettingsTile(Icons.location_on, 'Location Services', false, (val) {}),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withOpacity(0.2),
                    foregroundColor: AppColors.error,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('LOGOUT'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        if (title == 'Quiz History') 
          TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, bool value, Function(bool)? onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(title),
      trailing: onChanged != null 
        ? Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary)
        : const Icon(Icons.chevron_right),
      onTap: onChanged == null ? () {} : null,
    );
  }
}
