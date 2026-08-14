import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  List<dynamic> recentTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final incomeRes = await supabase
          .from('income')
          .select()
          .eq('user_uuid', userId);

      final expenseRes = await supabase
          .from('expenses')
          .select()
          .eq('user_uuid', userId);

      double inc = 0.0;
      for (var i in (incomeRes as List)) {
        inc += (i['amount'] as num).toDouble();
      }

      double exp = 0.0;
      for (var e in (expenseRes as List)) {
        exp += (e['amount'] as num).toDouble();
      }

      List<dynamic> combined = [];
      for (var i in incomeRes) {
        combined.add({...i, 'type': 'income'});
      }
      for (var e in expenseRes) {
        combined.add({...e, 'type': 'expense'});
      }

      combined.sort((a, b) {
        String dateA = a['date'] ?? '';
        String dateB = b['date'] ?? '';
        return dateB.compareTo(dateA);
      });

      setState(() {
        totalIncome = inc;
        totalExpense = exp;
        recentTransactions = combined.take(5).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddTransactionDialog(String type) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    final List<String> categories = type == 'income'
        ? ['Salary', 'Business', 'Freelance', 'Investment', 'Other']
        : ['Food', 'Bills', 'Transport', 'Shopping', 'Other'];

    String selectedCategory = categories[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(type == 'income' ? 'Add Income' : 'Add Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: categories.map((cat) {
                        bool isSelected = selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: type == 'income' ? Colors.green.shade100 : Colors.red.shade100,
                          onSelected: (bool selected) {
                            setStateDialog(() {
                              selectedCategory = cat;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: type == 'income' ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    final userId = supabase.auth.currentUser!.id;
                    final date = DateTime.now().toIso8601String().split('T')[0];

                    if (title.isNotEmpty && amount > 0) {
                      if (type == 'income') {
                        await supabase.from('income').insert({
                          'user_uuid': userId,
                          'title': title,
                          'amount': amount,
                          'category': selectedCategory,
                          'date': date,
                        });
                      } else {
                        await supabase.from('expenses').insert({
                          'user_uuid': userId,
                          'title': title,
                          'amount': amount,
                          'category': selectedCategory,
                          'date': date,
                        });
                      }

                      Navigator.pop(context);
                      _fetchDashboardData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${type == 'income' ? 'Income' : 'Expense'} added successfully!')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<String>(
        valueListenable: currencyNotifier,
        builder: (context, currency, _) {
          double netBalance = totalIncome - totalExpense;

          return RefreshIndicator(
            onRefresh: _fetchDashboardData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screenshot Jaisa Exact Green Banner Design
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669), // Emerald Green
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Net Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$currency${netBalance.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Income',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$currency${totalIncome.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Expense',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$currency${totalExpense.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons (Add Income & Add Expense)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _showAddTransactionDialog('income'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Income', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _showAddTransactionDialog('expense'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Expense', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Recent Transactions Section
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  recentTransactions.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('No transactions found yet.')),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = recentTransactions[index];
                      final isIncome = tx['type'] == 'income';
                      final amount = (tx['amount'] as num).toDouble();

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                            child: Icon(
                              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(tx['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${tx['category'] ?? 'General'} • ${tx['date'] ?? ''}'),
                          trailing: Text(
                            '${isIncome ? '+' : '-'}$currency${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}