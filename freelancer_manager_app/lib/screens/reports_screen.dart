import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Stats')),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return FutureBuilder<double>(
            future: provider.getTotalExpenses(),
            builder: (context, snapshot) {
              final earnings = provider.getTotalEarnings();
              final expenses = snapshot.data ?? 0.0;
              final net = earnings - expenses;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryCard(earnings, expenses, net),
                    const SizedBox(height: 24),
                    const Text('Financial Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    if (earnings > 0 || expenses > 0)
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: earnings,
                                title: 'Earnings',
                                color: Colors.green,
                                radius: 50,
                                titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              PieChartSectionData(
                                value: expenses,
                                title: 'Expenses',
                                color: Colors.red,
                                radius: 50,
                                titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Center(child: Text('No data to display chart')),
                    const SizedBox(height: 32),
                    _buildStatList(provider),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(double earnings, double expenses, double net) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Total Net Balance', style: TextStyle(color: Colors.grey)),
            Text('\$${net.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSimpleStat('Total Earnings', '\$${earnings.toStringAsFixed(0)}', Colors.green),
                _buildSimpleStat('Total Expenses', '\$${expenses.toStringAsFixed(0)}', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildStatList(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Project Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Total Projects'),
                trailing: Text(provider.projects.length.toString()),
              ),
              ListTile(
                title: const Text('Completed Projects'),
                trailing: Text(provider.projects.where((p) => p.status == 'Completed').length.toString()),
              ),
              ListTile(
                title: const Text('Total Clients'),
                trailing: Text(provider.clients.length.toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
