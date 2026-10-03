import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../supabase_service.dart';
import '../theme.dart';
import 'assets_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await context.read<SupabaseService>().getDashboardStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<SupabaseService>().signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Here is what\'s happening with your assets today.'),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('Total Assets', _stats?['total']?.toString() ?? '0', Icons.inventory, AppColors.primary, 
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetsListScreen()))),
                        _buildStatCard('Available', _stats?['available']?.toString() ?? '0', Icons.check_circle, AppColors.secondary,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetsListScreen()))),
                        _buildStatCard('Assigned', _stats?['assigned']?.toString() ?? '0', Icons.person, AppColors.accent,
                          onTap: () => Navigator.pushNamed(context, '/employees')),
                        _buildStatCard('Maintenance', _stats?['maintenance']?.toString() ?? '0', Icons.build, AppColors.error,
                          onTap: () => Navigator.pushNamed(context, '/maintenance')),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildActionTile(
                      context,
                      'Manage Assets',
                      'View, add, or edit office equipment',
                      Icons.devices,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetsListScreen())),
                    ),
                    _buildActionTile(
                      context,
                      'Employees',
                      'Manage staff and asset assignments',
                      Icons.people,
                      () => Navigator.pushNamed(context, '/employees'),
                    ),
                    _buildActionTile(
                      context,
                      'Departments',
                      'Manage office departments',
                      Icons.corporate_fare,
                      () => Navigator.pushNamed(context, '/departments'),
                    ),
                    _buildActionTile(
                      context,
                      'Maintenance',
                      'Track repairs and service history',
                      Icons.build,
                      () => Navigator.pushNamed(context, '/maintenance'),
                    ),
                    _buildActionTile(
                      context,
                      'Profile',
                      'Manage your account and settings',
                      Icons.settings,
                      () => Navigator.pushNamed(context, '/profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
