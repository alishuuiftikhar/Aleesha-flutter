import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPayments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final payments = snapshot.data ?? [];
          if (payments.isEmpty) {
            return const Center(child: Text('No payment records found.'));
          }
          return ListView.builder(
            itemCount: payments.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final payment = payments[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Colors.green),
                  title: Text('Amount: \$${(payment['amount'] as num).toStringAsFixed(2)}'),
                  subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(payment['payment_date']))}'),
                  trailing: Text(payment['payment_method'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPayments() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('payments', orderBy: 'payment_date DESC');
  }
}
