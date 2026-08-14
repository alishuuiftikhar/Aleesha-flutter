import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';

class MyFinesScreen extends StatelessWidget {
  const MyFinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fines = context.watch<DataProvider>().myFines;

    return Scaffold(
      appBar: AppBar(title: const Text('My Fines')),
      body: fines.isEmpty
          ? const Center(child: Text('No fines found.'))
          : ListView.builder(
              itemCount: fines.length,
              itemBuilder: (context, index) {
                final fine = fines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Rs. ${fine.amount}'),
                    subtitle: Text(fine.reason),
                    trailing: Text(
                      fine.status.toUpperCase(),
                      style: TextStyle(
                        color: fine.status == 'unpaid' ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
