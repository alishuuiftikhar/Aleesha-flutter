import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import 'create_order_screen.dart';
import 'order_details_screen.dart';
import 'package:intl/intl.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _ordersFuture = Provider.of<SupabaseService>(context, listen: false).getProductionOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturing Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateOrderScreen()),
              ).then((_) {
                setState(() {
                  _loadOrders();
                });
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ...AppConstants.productionStatuses].map((status) {
                  final isSelected = _statusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _statusFilter = status);
                        }
                      },
                      selectedColor: AppConstants.primaryColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : AppConstants.textColor),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                var orders = snapshot.data ?? [];
                if (_statusFilter != 'All') {
                  orders = orders.where((o) => o['status'] == _statusFilter).toList();
                }

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('No production orders found'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final product = order['products'];
                    final statusColor = _getStatusColor(order['status']);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
                        ).then((_) => setState(() => _loadOrders())),
                        title: Text('Order #${order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'], style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Qty: ${order['quantity']} | Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(order['created_at']))}'),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.grey;
      case 'Scheduled': return Colors.blue;
      case 'In Production': return AppConstants.highlightColor;
      case 'Paused': return Colors.orange;
      case 'Completed': return AppConstants.successColor;
      case 'Cancelled': return AppConstants.errorColor;
      default: return Colors.black;
    }
  }
}
