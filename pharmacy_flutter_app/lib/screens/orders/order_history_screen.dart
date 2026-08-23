import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../utils/theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Card(
                color: AppColors.cardBackground,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(order.createdAt)} - ${order.status}',
                    style: TextStyle(
                      color: order.status == 'Pending' ? Colors.orange : AppColors.success,
                    ),
                  ),
                  trailing: Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                  ),
                  children: [
                    if (order.items != null)
                      ...order.items!.map((item) => ListTile(
                            title: Text(item.medicine?.name ?? 'Unknown Medicine'),
                            subtitle: Text('Qty: ${item.quantity}'),
                            trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                          )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
