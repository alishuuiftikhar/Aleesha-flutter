import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  String _searchQuery = '';
  String _filterType = 'All'; // All, Income, Expense

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final income = await supabase.from('income').select().eq('user_uuid', userId);
      final expenses = await supabase.from('expenses').select().eq('user_uuid', userId);

      List<Map<String, dynamic>> combined = [];
      for (var i in income) {
        combined.add({...i, 'type': 'income'});
      }
      for (var e in expenses) {
        combined.add({...e, 'type': 'expense'});
      }

      combined.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

      setState(() {
        _transactions = combined;
        _filterAndSearch();
      });
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
  }

  void _filterAndSearch() {
    setState(() {
      _filteredTransactions = _transactions.where((tx) {
        final matchesSearch = tx['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (tx['category'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());

        if (_filterType == 'Income') {
          return matchesSearch && tx['type'] == 'income';
        } else if (_filterType == 'Expense') {
          return matchesSearch && tx['type'] == 'expense';
        }
        return matchesSearch;
      }).toList();
    });
  }

  // Delete Transaction Function
  Future<void> _deleteTransaction(String id, String type) async {
    try {
      final table = type == 'income' ? 'income' : 'expenses';
      await supabase.from(table).delete().eq('id', id);
      _fetchTransactions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Edit Transaction Dialog
  void _showEditModal(Map<String, dynamic> tx) {
    final titleController = TextEditingController(text: tx['title']);
    final amountController = TextEditingController(text: tx['amount'].toString());
    String selectedCategory = tx['category'] ?? 'General';
    final isIncome = tx['type'] == 'income';

    final List<String> incomeCategories = ['Salary', 'Freelance', 'Investment', 'Gift', 'Other'];
    final List<String> expenseCategories = ['Food', 'Transport', 'Bills', 'Shopping', 'Entertainment', 'Other'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ${isIncome ? 'Income' : 'Expense'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title / Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (\$)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: (isIncome ? incomeCategories : expenseCategories)
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    double? amount = double.tryParse(amountController.text.trim());
                    if (amount == null || titleController.text.isEmpty) return;

                    final table = isIncome ? 'income' : 'expenses';
                    await supabase.from(table).update({
                      'title': titleController.text.trim(),
                      'amount': amount,
                      'category': selectedCategory,
                    }).eq('id', tx['id']);

                    Navigator.pop(context);
                    _fetchTransactions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction updated successfully')),
                    );
                  },
                  child: const Text('Update Transaction', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: Column(
        children: [
          // Search & Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search title or category...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _filterAndSearch();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterType,
                  items: ['All', 'Income', 'Expense']
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _filterType = val);
                      _filterAndSearch();
                    }
                  },
                ),
              ],
            ),
          ),

          // History List with Edit & Delete Buttons
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(child: Text('No transactions found'))
                : ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final tx = _filteredTransactions[index];
                final isIncome = tx['type'] == 'income';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${tx['category'] ?? 'General'} • ${tx['date'].toString().split('T')[0]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${isIncome ? '+' : '-'}\$${tx['amount']}',
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                          onPressed: () => _showEditModal(tx),
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () async {
                            bool? confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Transaction'),
                                content: const Text('Are you sure you want to delete this?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              _deleteTransaction(tx['id'], tx['type']);
                            }
                          },
                        ),
                      ],
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
}