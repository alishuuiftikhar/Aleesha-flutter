import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/order.dart';
import '../../utils/theme.dart';

class ViewOrdersScreen extends StatefulWidget {
  const ViewOrdersScreen({super.key});

  @override
  State<ViewOrdersScreen> createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  final _supabase = SupabaseService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _supabase.getAllOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Orders')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ListTile(
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text('Status: ${order.status} | Total: \$${order.totalAmount}'),
                  trailing: DropdownButton<String>(
                    value: order.status,
                    items: ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (newStatus) async {
                      if (newStatus != null) {
                        await _supabase.updateOrderStatus(order.id, newStatus);
                        _fetchOrders();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
