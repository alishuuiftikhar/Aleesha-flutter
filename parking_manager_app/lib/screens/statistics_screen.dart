import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/app_colors.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DBHelper _dbHelper = DBHelper();
  double _totalRevenue = 0;
  int _totalTransactions = 0;
  List<Map<String, dynamic>> _recentPayments = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final revenueData = await _dbHelper.rawQuery("SELECT SUM(amount) as total, COUNT(*) as count FROM payments");
    final paymentsData = await _dbHelper.rawQuery('''
      SELECT p.*, v.plate_number 
      FROM payments p
      JOIN parking_sessions s ON p.session_id = s.id
      JOIN vehicles v ON s.vehicle_id = v.id
      ORDER BY p.payment_date DESC
      LIMIT 10
    ''');

    setState(() {
      _totalRevenue = (revenueData.first['total'] ?? 0.0).toDouble();
      _totalTransactions = revenueData.first['count'] ?? 0;
      _recentPayments = paymentsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Revenue Statistics', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 30),
            const Text('Recent Payments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text)),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentPayments.length,
              itemBuilder: (context, index) {
                final payment = _recentPayments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.attach_money, color: Colors.white)),
                    title: Text(payment['plate_number'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(payment['payment_date'].toString().substring(0, 16)),
                    trailing: Text('\$${payment['amount'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent, fontSize: 16)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('Total Revenue Generated', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Text('\$${_totalRevenue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Transactions', _totalTransactions.toString()),
              _buildSummaryItem('Avg / Session', '\$${_totalTransactions > 0 ? (_totalRevenue / _totalTransactions).toStringAsFixed(2) : "0.00"}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
