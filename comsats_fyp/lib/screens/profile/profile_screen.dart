import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../resources/resource_hub_screen.dart';
import '../resources/documentation_screen.dart';
import '../resources/faq_screen.dart';
import '../resources/guidelines_screen.dart';
import '../help/contact_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(user.name.isNotEmpty ? user.name[0] : '?',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 3),
                        Text(user.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                        const SizedBox(height: 6),
                        Chip(
                          label: Text(user.role.label, style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('Registration Number'), subtitle: Text(user.regNumber)),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.apartment_outlined), title: const Text('Department'), subtitle: Text(user.department)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Resources', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _navTile(context, Icons.hub_outlined, 'Resource Hub', const ResourceHubScreen()),
                const Divider(height: 1),
                _navTile(context, Icons.description_outlined, 'Documentation', const DocumentationScreen()),
                const Divider(height: 1),
                _navTile(context, Icons.help_outline, 'FAQ', const FaqScreen()),
                const Divider(height: 1),
                _navTile(context, Icons.rule_outlined, 'Guidelines', const GuidelinesScreen()),
                const Divider(height: 1),
                _navTile(context, Icons.support_agent_outlined, 'Contact & Help Desk', const ContactScreen()),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Logout', style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)),
    );
  }
}
