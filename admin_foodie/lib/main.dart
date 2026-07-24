import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Same Supabase Database Credentials
  await Supabase.initialize(
    url: 'https://jtwbrngtiihkkzhpjecl.supabase.co',
    anonKey: 'sb_publishable_djeRN-zE5IGImgWxdfE7Zg_9r1UeO-O',
  );
  runApp(const FoodAdminApp());
}

class FoodAdminApp extends StatelessWidget {
  const FoodAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodie Admin',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF3E5F5),
      ),
      home: const AdminHomeScreen(),
    );
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final supabase = Supabase.instance.client;
  final List<String> statusSteps = ['Pending', 'Preparing', 'Out for Delivery', 'Delivered'];

  // Status Change function
  Future<void> updateOrderStatus(dynamic id, String newStatus) async {
    try {
      await supabase.from('orders').update({'status': newStatus}).eq('id', id);
      _showSnack('Order status updated to "$newStatus" ✅', Colors.green);
    } catch (e) {
      _showSnack('Error updating status: $e', Colors.red);
    }
  }

  // Delete Order function
  Future<void> deleteOrder(dynamic id) async {
    try {
      await supabase.from('orders').delete().eq('id', id);
      _showSnack('Order deleted successfully 🗑️', Colors.redAccent);
    } catch (e) {
      _showSnack('Error deleting order: $e', Colors.red);
    }
  }

  void _showSnack(String msg, Color bg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: bg, duration: const Duration(seconds: 2)),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Preparing':
        return Colors.orange;
      case 'Out for Delivery':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard 🛠️', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload Database',
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabase.from('orders').stream(primaryKey: ['id']).order('created_at', ascending: false),
          builder: (context, snapshot) {
            // Error Handling
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 10),
                      Text(
                        'Database Connection Error:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Loading Indicator
            if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Connecting to Database... ⏳', style: TextStyle(color: Colors.deepPurple)),
                  ],
                ),
              );
            }

            final orders = snapshot.data!;

            // Empty Database Check
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    const Text(
                      'No Orders Found in Database 📋',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('New customer orders will show up here live.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              );
            }

            // Orders Table / List
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final currentStatus = order['status'] ?? 'Pending';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Order #${orders.length - index} - ${order['item_name']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepPurple),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Order?'),
                                    content: const Text('Are you sure you want to remove this order permanently?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteOrder(order['id']);
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 10),

                        // Order Details
                        Text('👤 Customer: ${order['customer_name'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('📞 Phone: ${order['phone_number'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                        Text('💰 Bill: Rs. ${order['total_bill'] ?? '0'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                        Text('💳 Payment Method: ${order['payment_method'] ?? 'COD'}', style: const TextStyle(fontSize: 12)),
                        Text('📅 Time: ${order['order_date'] ?? 'N/A'}', style: const TextStyle(fontSize: 11, color: Colors.grey)),

                        const SizedBox(height: 8),

                        // Current Status
                        Row(
                          children: [
                            const Text('Current Status: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Chip(
                              label: Text(
                                currentStatus.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: _getStatusColor(currentStatus),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Text('Update Order Status:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 6),

                        // Quick Action Buttons
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: statusSteps.map((status) {
                            final isCurrent = currentStatus == status;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCurrent ? Colors.grey[400] : _getStatusColor(status),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: isCurrent ? null : () => updateOrderStatus(order['id'], status),
                              child: Text(
                                status,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}