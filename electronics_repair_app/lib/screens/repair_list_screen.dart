import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/repair_provider.dart';
import '../models/repair_order.dart';
import '../theme/app_theme.dart';
import 'add_repair_screen.dart';
import 'repair_detail_screen.dart';
import '../database/database_helper.dart';

class RepairListScreen extends StatefulWidget {
  const RepairListScreen({super.key});

  @override
  State<RepairListScreen> createState() => _RepairListScreenState();
}

class _RepairListScreenState extends State<RepairListScreen> {
  String _filterStatus = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Orders'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by customer or device...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
              ),
              _buildFilterBar(),
            ],
          ),
        ),
      ),
      body: Consumer<RepairProvider>(
        builder: (context, provider, child) {
          var filteredList = _filterStatus == 'All'
              ? provider.repairOrders
              : provider.repairOrders.where((element) => element['status'] == _filterStatus).toList();

          if (_searchQuery.isNotEmpty) {
            filteredList = filteredList.where((element) {
              final customer = element['customer_name'].toString().toLowerCase();
              final device = element['device_model'].toString().toLowerCase();
              return customer.contains(_searchQuery) || device.contains(_searchQuery);
            }).toList();
          }

          if (filteredList.isEmpty) {
            return const Center(child: Text('No repair orders found.'));
          }

          return ListView.builder(
            itemCount: filteredList.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final repair = filteredList[index];
              return _buildRepairCard(context, repair);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRepairScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar() {
    final statuses = ['All', ...RepairStatus.values.map((e) => e.name)];
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _filterStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _filterStatus = status);
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.textColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepairCard(BuildContext context, Map<String, dynamic> repair) {
    final status = RepairStatus.values.byName(repair['status']);
    final color = _getStatusColor(status);

    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RepairDetailScreen(repair: repair))),
        child: Column(
          children: [
            ListTile(
            title: Text('${repair['device_type']} - ${repair['device_model']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('ID: #${repair['id']} | Customer: ${repair['customer_name']}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Text(
                repair['status'],
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Technician: ${repair['technician_name']}', style: const TextStyle(fontSize: 12)),
                    Text('Est. Cost: \$${repair['estimated_cost']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    if (repair['status'] == 'Ready' || repair['status'] == 'Delivered')
                      IconButton(
                        icon: const Icon(Icons.payment, color: Colors.green),
                        onPressed: () => _showPaymentDialog(context, repair['id'], repair['estimated_cost']),
                        tooltip: 'Record Payment',
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                      onPressed: () => _showStatusUpdateDialog(context, repair['id'], status),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => Provider.of<RepairProvider>(context, listen: false).deleteRepairOrder(repair['id']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Color _getStatusColor(RepairStatus status) {
    switch (status) {
      case RepairStatus.Received: return Colors.blue;
      case RepairStatus.Diagnosing: return Colors.orange;
      case RepairStatus.WaitingForParts: return Colors.purple;
      case RepairStatus.Repairing: return Colors.indigo;
      case RepairStatus.Ready: return Colors.green;
      case RepairStatus.Delivered: return Colors.teal;
      case RepairStatus.Cancelled: return Colors.red;
    }
  }

  void _showPaymentDialog(BuildContext context, int repairId, double amount) {
    final amountController = TextEditingController(text: amount.toString());
    String method = 'Cash';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: method,
              items: ['Cash', 'Card', 'Transfer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => method = val!,
              decoration: const InputDecoration(labelText: 'Payment Method'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final finalAmount = double.tryParse(amountController.text) ?? 0.0;
              await DatabaseHelper.instance.insert('payments', {
                'repair_order_id': repairId,
                'amount': finalAmount,
                'payment_date': DateTime.now().toIso8601String(),
                'payment_method': method,
              });
              if (context.mounted) {
                Provider.of<RepairProvider>(context, listen: false).fetchAllData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment recorded!')));
              }
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, int id, RepairStatus currentStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Repair Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: RepairStatus.values.map((status) {
            return ListTile(
              title: Text(status.name),
              leading: Radio<RepairStatus>(
                value: status,
                groupValue: currentStatus,
                onChanged: (val) {
                  if (val != null) {
                    Provider.of<RepairProvider>(context, listen: false).updateRepairStatus(id, val);
                    Navigator.pop(context);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
