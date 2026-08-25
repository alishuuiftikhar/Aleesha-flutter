import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.mainText),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: provider.loadAllData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${provider.student?.name ?? "Student"}!',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here is your career overview',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      StatCard(
                        title: 'Total Internships',
                        value: provider.totalInternships.toString(),
                        icon: Icons.work,
                        iconColor: AppColors.primary,
                      ),
                      StatCard(
                        title: 'Ongoing',
                        value: provider.ongoingInternships.toString(),
                        icon: Icons.sync,
                        iconColor: AppColors.accent,
                      ),
                      StatCard(
                        title: 'Certificates',
                        value: provider.totalCertificates.toString(),
                        icon: Icons.verified,
                        iconColor: AppColors.highlight,
                      ),
                      StatCard(
                        title: 'Upcoming',
                        value: provider.upcomingInternships.toString(),
                        icon: Icons.event,
                        iconColor: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ongoing Internships',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {}, // Navigate to full list
                        child: const Text('View All', style: TextStyle(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (provider.internships.isEmpty)
                    _buildEmptyState(context, 'No internships yet', Icons.work_off_outlined)
                  else
                    ...provider.internships
                        .where((i) => i.status == 'Ongoing')
                        .map((i) => _buildRecentInternshipCard(context, i, provider))
                        .toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentInternshipCard(BuildContext context, dynamic internship, AppProvider provider) {
    final company = provider.getCompanyById(internship.companyId);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          internship.position,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(company?.name ?? 'Unknown Company'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: internship.calculateProgress(),
              backgroundColor: AppColors.secondaryBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Ongoing',
            style: TextStyle(color: AppColors.success, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(icon, size: 64, color: AppColors.secondaryBackground),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}
