import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import 'customers_screen.dart';
import 'products_screen.dart';
import 'invoices_screen.dart';
import 'placeholder_screen.dart';

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
      context.read<AppProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currencyFormat = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchData(),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.text,
                        ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        'Total Invoices',
                        "${provider.stats['totalInvoices'] ?? 0}",
                        Icons.description,
                        AppTheme.primary,
                      ),
                      _buildStatCard(
                        'Total Revenue',
                        currencyFormat.format(provider.stats['totalRevenue'] ?? 0),
                        Icons.monetization_on,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Pending Invoices',
                        "${provider.stats['unpaidCount'] ?? 0}",
                        Icons.pending_actions,
                        AppTheme.accent,
                      ),
                      _buildStatCard(
                        'Pending Amount',
                        currencyFormat.format(provider.stats['pendingAmount'] ?? 0),
                        Icons.account_balance_wallet,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent Invoices',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (provider.invoices.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No invoices yet'),
                    ))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.invoices.length > 5 ? 5 : provider.invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = provider.invoices[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text('Invoice #${invoice.id.substring(0, 8)}'),
                            subtitle: Text(DateFormat.yMMMd().format(invoice.date)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormat.format(invoice.total),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(invoice.status).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    invoice.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _getStatusColor(invoice.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return AppTheme.accent;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.secondaryBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.accent,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 35),
                ),
                const SizedBox(height: 10),
                Text(
                  'InvoicePro Admin',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _drawerItem(context, Icons.dashboard, 'Dashboard', () => Navigator.pop(context)),
          _drawerItem(context, Icons.people, 'Customers', () => _navigateTo(context, const CustomersScreen())),
          _drawerItem(context, Icons.inventory, 'Products & Services', () => _navigateTo(context, const ProductsScreen())),
          _drawerItem(context, Icons.description, 'Invoices', () => _navigateTo(context, const InvoicesScreen())),
          const Divider(),
          _drawerItem(context, Icons.bar_chart, 'Reports', () => _navigateTo(context, const PlaceholderScreen(title: 'Reports'))),
          _drawerItem(context, Icons.settings, 'Settings', () => _navigateTo(context, const PlaceholderScreen(title: 'Settings'))),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
