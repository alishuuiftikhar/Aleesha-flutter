import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Planner')),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(provider),
                const SizedBox(height: 24),
                Text('Spending Chart', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildChart(provider),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),
                _buildRecentTransactions(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(FinanceProvider provider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
              Text(
                '\$${provider.balance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _smallSummaryCard(
                'Income',
                provider.totalIncome,
                Icons.arrow_upward,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _smallSummaryCard(
                'Expenses',
                provider.totalExpenses,
                Icons.arrow_downward,
                Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallSummaryCard(String title, double amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(FinanceProvider provider) {
    if (provider.transactions.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No transaction data yet')),
      );
    }
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _getSections(provider),
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections(FinanceProvider provider) {
    // Group expenses by category
    Map<int, double> categorySums = {};
    for (var t in provider.transactions.where((t) => t.type == 'expense')) {
      categorySums[t.categoryId] = (categorySums[t.categoryId] ?? 0) + t.amount;
    }

    if (categorySums.isEmpty) return [];

    return categorySums.entries.map((entry) {
      final category = provider.categories.firstWhere((c) => c.id == entry.key);
      return PieChartSectionData(
        color: Color(category.color),
        value: entry.value,
        title: '${(entry.value / provider.totalExpenses * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildRecentTransactions(FinanceProvider provider) {
    final recent = provider.transactions.take(5).toList();
    if (recent.isEmpty) return const Text('No transactions yet.');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      itemBuilder: (context, index) {
        final t = recent[index];
        final cat = provider.categories.firstWhere((c) => c.id == t.categoryId);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(cat.color).withOpacity(0.2),
            child: Icon(_getIcon(cat.icon), color: Color(cat.color)),
          ),
          title: Text(t.title),
          subtitle: Text(DateFormat('MMM dd, yyyy').format(t.date)),
          trailing: Text(
            '${t.type == 'income' ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: t.type == 'income' ? Colors.green : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'fastfood': return Icons.fastfood;
      case 'directions_car': return Icons.directions_car;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'payments': return Icons.payments;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
