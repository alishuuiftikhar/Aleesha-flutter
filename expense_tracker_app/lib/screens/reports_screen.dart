import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Is line se currencyNotifier ka error khatam hojaye ga

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  final supabase = Supabase.instance.client;
  double totalIncome = 0;
  double totalExpense = 0;
  Map<String, double> expenseCategories = {};

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final incomeRes = await supabase.from('income').select('amount').eq('user_uuid', userId);
      final expenseRes = await supabase.from('expenses').select('amount, category').eq('user_uuid', userId);

      double inc = 0.0;
      for (var i in (incomeRes as List)) {
        inc += (i['amount'] as num).toDouble();
      }

      double exp = 0.0;
      Map<String, double> catMap = {};

      for (var e in (expenseRes as List)) {
        double amt = (e['amount'] as num).toDouble();
        exp += amt;
        String cat = e['category']?.toString() ?? 'General';
        catMap[cat] = (catMap[cat] ?? 0) + amt;
      }

      setState(() {
        totalIncome = inc;
        totalExpense = exp;
        expenseCategories = catMap;
      });
    } catch (e) {
      debugPrint('Error loading reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Reports')),
      body: ValueListenableBuilder<String>(
        valueListenable: currencyNotifier,
        builder: (context, currency, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Income vs Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: totalIncome == 0 && totalExpense == 0
                      ? const Center(child: Text('No data available for charts'))
                      : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: totalIncome == 0 ? 0.001 : totalIncome,
                          color: const Color(0xFF10B981),
                          title: 'Income',
                          radius: 60,
                          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          value: totalExpense == 0 ? 0.001 : totalExpense,
                          color: Colors.redAccent,
                          title: 'Expense',
                          radius: 60,
                          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Expense Breakdown by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                expenseCategories.isEmpty
                    ? const Text('No expenses recorded yet.')
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenseCategories.keys.length,
                  itemBuilder: (context, index) {
                    String cat = expenseCategories.keys.elementAt(index);
                    double amt = expenseCategories[cat]!;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.category, color: Color(0xFF059669)),
                        title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('$currency${amt.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
}