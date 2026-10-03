import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';
import 'project_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Freelancer Manager')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final earnings = provider.getTotalEarnings();
          final activeProjects = provider.projects.where((p) => p.status == 'Active').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      'Total Earnings',
                      '\$${earnings.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Active Projects',
                      activeProjects.toString(),
                      Icons.rocket_launch,
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(context, 'Project', Icons.add_task, () {
                          // Could open add dialog or navigate to projects
                        }),
                        _buildActionButton(context, 'Client', Icons.person_add_alt_1, () {}),
                        _buildActionButton(context, 'Expense', Icons.money_off, () {}),
                        _buildActionButton(context, 'Timer', Icons.play_circle_fill, () {}),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (provider.projects.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No projects yet. Start by adding one!'),
                  ))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.projects.length > 3 ? 3 : provider.projects.length,
                    itemBuilder: (context, index) {
                      final project = provider.projects[index];
                      return Card(
                        child: ListTile(
                          title: Text(project.name),
                          subtitle: Text('Due: ${DateFormat.yMMMd().format(project.deadline)}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project)),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: Icon(icon, color: Theme.of(context).primaryColor),
          padding: const EdgeInsets.all(12),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
