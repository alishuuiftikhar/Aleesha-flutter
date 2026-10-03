import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildAdminCard(context, Icons.people, 'Manage Members', AppColors.primary),
          _buildAdminCard(context, Icons.card_membership, 'Manage Plans', AppColors.secondary),
          _buildAdminCard(context, Icons.sports, 'Manage Sports', AppColors.accent),
          _buildAdminCard(context, Icons.person_add, 'Manage Coaches', AppColors.success),
          _buildAdminCard(context, Icons.calendar_month, 'Class Schedules', AppColors.warning),
          _buildAdminCard(context, Icons.analytics, 'Reports', Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, IconData icon, String label, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
