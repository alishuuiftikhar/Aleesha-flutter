import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class FineManagementScreen extends StatefulWidget {
  const FineManagementScreen({super.key});

  @override
  State<FineManagementScreen> createState() => _FineManagementScreenState();
}

class _FineManagementScreenState extends State<FineManagementScreen> {
  String _filter = 'all'; // all, paid, unpaid
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().fetchAllFines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final allFines = data.allFines;
    
    final filteredFines = allFines.where((f) {
      bool matchesFilter = _filter == 'all' || f['status'] == _filter;
      bool matchesSearch = f['profiles']['full_name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
                          f['profiles']['student_id'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    final totalAmount = allFines.fold(0.0, (sum, f) => sum + (f['amount'] as num).toDouble());
    final paidAmount = allFines.where((f) => f['status'] == 'paid').fold(0.0, (sum, f) => sum + (f['amount'] as num).toDouble());
    final unpaidAmount = totalAmount - paidAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('💰 Fine Management')),
      body: Column(
        children: [
          // Stat Cards
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.05),
            child: Row(
              children: [
                _miniStat('Total', totalAmount.toInt().toString(), Colors.blue),
                _miniStat('Paid', paidAmount.toInt().toString(), Colors.green),
                _miniStat('Unpaid', unpaidAmount.toInt().toString(), Colors.red),
              ],
            ),
          ),
          
          // Search & Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by student name or ID...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _filterChip('all', 'All'),
                    _filterChip('unpaid', 'Unpaid'),
                    _filterChip('paid', 'Paid'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: data.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : filteredFines.isEmpty
                ? const Center(child: Text('No fines found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFines.length,
                    itemBuilder: (context, index) {
                      final fine = filteredFines[index];
                      final isPaid = fine['status'] == 'paid';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isPaid ? Colors.green[100] : Colors.red[100],
                            child: Icon(isPaid ? Icons.check : Icons.warning, color: isPaid ? Colors.green : Colors.red),
                          ),
                          title: Text(fine['profiles']['full_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${fine['profiles']['student_id']} | Rs. ${fine['amount']}'),
                              Text(DateFormat('dd MMM yyyy').format(DateTime.parse(fine['created_at'])), style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          trailing: isPaid 
                            ? const Text('PAID', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))
                            : ElevatedButton(
                                onPressed: () => _confirmMarkPaid(fine['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  minimumSize: const Size(60, 30),
                                ),
                                child: const Text('Mark Paid', style: TextStyle(fontSize: 10)),
                              ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _filterChip(String id, String label) {
    final isSelected = _filter == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _filter = id);
      },
      selectedColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12),
    );
  }

  void _confirmMarkPaid(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('Mark this fine as paid? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<DataProvider>().payFine(id);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
