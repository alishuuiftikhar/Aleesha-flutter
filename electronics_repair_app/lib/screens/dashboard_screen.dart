import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/repair_provider.dart';
import '../theme/app_theme.dart';
import 'repair_list_screen.dart';
import 'customer_list_screen.dart';
import 'part_list_screen.dart';
import 'add_repair_screen.dart';

import 'settings_screen.dart';
import 'profile_screen.dart';

import 'payment_list_screen.dart';
import 'repair_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepairProvider>(context, listen: false).fetchAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechFix Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<RepairProvider>(context, listen: false).fetchAllData(),
          ),
        ],
      ),
      body: Consumer<RepairProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(provider),
                const SizedBox(height: 24),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                const Text(
                  'Recent Repairs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildRecentRepairs(provider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRepairScreen()));
        },
        tooltip: 'New Repair',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsRow(RepairProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pending',
            provider.getPendingRepairsCount().toString(),
            Icons.pending_actions,
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FutureBuilder<double>(
            future: provider.getRevenue(),
            builder: (context, snapshot) {
              return _buildStatCard(
                'Revenue',
                '\$${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                Icons.attach_money,
                AppTheme.accentColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _buildActionTile(context, 'Repairs', Icons.build, Colors.blue, const RepairListScreen()),
        _buildActionTile(context, 'Customers', Icons.people, Colors.green, const CustomerListScreen()),
        _buildActionTile(context, 'Inventory', Icons.inventory, Colors.orange, const PartListScreen()),
        _buildActionTile(context, 'Payments', Icons.payment, Colors.teal, const PaymentListScreen()),
        _buildActionTile(context, 'Settings', Icons.settings, Colors.blueGrey, const SettingsScreen()),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, String title, IconData icon, Color color, Widget? screen) {
    return InkWell(
      onTap: () {
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRepairs(RepairProvider provider) {
    if (provider.repairOrders.isEmpty) {
      return const Center(child: Text('No repairs yet.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.repairOrders.length > 5 ? 5 : provider.repairOrders.length,
      itemBuilder: (context, index) {
        final repair = provider.repairOrders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
              child: const Icon(Icons.laptop, color: AppTheme.primaryColor),
            ),
            title: Text('${repair['device_type']} - ${repair['device_model']}'),
            subtitle: Text('Status: ${repair['status']} | ${repair['customer_name']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => RepairDetailScreen(repair: repair)));
            },
          ),
        );
      },
    );
  }
}
