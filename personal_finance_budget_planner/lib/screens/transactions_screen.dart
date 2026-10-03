import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _filterType = 'All'; // All, Income, Expense
  int? _filterCategoryId;
  DateTime? _filterDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _selectDate(context),
          ),
          if (_filterDate != null || _filterCategoryId != null || _filterType != 'All')
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => setState(() {
                _filterType = 'All';
                _filterCategoryId = null;
                _filterDate = null;
              }),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: AppTheme.cardBackground,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: Consumer<FinanceProvider>(
              builder: (context, provider, child) {
                var list = provider.transactions;
                if (_searchQuery.isNotEmpty) {
                  list = list.where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                }
                if (_filterType == 'Income') {
                  list = list.where((t) => t.type == 'income').toList();
                } else if (_filterType == 'Expense') {
                  list = list.where((t) => t.type == 'expense').toList();
                }
                if (_filterCategoryId != null) {
                  list = list.where((t) => t.categoryId == _filterCategoryId).toList();
                }
                if (_filterDate != null) {
                  list = list.where((t) => 
                    t.date.year == _filterDate!.year && 
                    t.date.month == _filterDate!.month && 
                    t.date.day == _filterDate!.day).toList();
                }

                if (list.isEmpty) return const Center(child: Text('No transactions found.'));

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final t = list[index];
                    final cat = provider.categories.firstWhere((c) => c.id == t.categoryId);
                    return Dismissible(
                      key: Key(t.id.toString()),
                      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                      onDismissed: (direction) => provider.deleteTransaction(t.id!),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(cat.color).withOpacity(0.2),
                          child: Icon(_getIcon(cat.icon), color: Color(cat.color)),
                        ),
                        title: Text(t.title),
                        subtitle: Text(DateFormat('MMM dd, yyyy').format(t.date)),
                        trailing: Text(
                          '${t.type == 'income' ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: t.type == 'income' ? Colors.green : Colors.redAccent,
                            fontWeight: FontWeight.bold,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _filterDate) {
      setState(() {
        _filterDate = picked;
      });
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type:'),
            DropdownButton<String>(
              value: _filterType,
              items: ['All', 'Income', 'Expense'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) {
                setState(() => _filterType = val!);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            const Text('Category:'),
            DropdownButton<int?>(
              value: _filterCategoryId,
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('All')),
                ...Provider.of<FinanceProvider>(context, listen: false).categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              ],
              onChanged: (val) {
                setState(() => _filterCategoryId = val);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    int? selectedCategoryId;
    String type = 'expense';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Transaction', style: Theme.of(context).textTheme.titleLarge),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              Consumer<FinanceProvider>(
                builder: (context, provider, child) => DropdownButtonFormField<int>(
                  hint: const Text('Category'),
                  value: selectedCategoryId,
                  items: provider.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  onChanged: (val) => setModalState(() => selectedCategoryId = val),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(title: const Text('Expense'), value: 'expense', groupValue: type, onChanged: (val) => setModalState(() => type = val.toString())),
                  ),
                  Expanded(
                    child: RadioListTile(title: const Text('Income'), value: 'income', groupValue: type, onChanged: (val) => setModalState(() => type = val.toString())),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty && amountController.text.isNotEmpty && selectedCategoryId != null) {
                    Provider.of<FinanceProvider>(context, listen: false).addTransaction(TransactionModel(
                      title: titleController.text,
                      amount: double.parse(amountController.text),
                      date: DateTime.now(),
                      categoryId: selectedCategoryId!,
                      type: type,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'fastfood': return Icons.fastfood;
      case 'directions_car': return Icons.directions_car;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'movie': return Icons.movie;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'payments': return Icons.payments;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
