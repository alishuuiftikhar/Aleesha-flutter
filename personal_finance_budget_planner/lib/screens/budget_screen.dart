import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/finance_provider.dart';
import '../models/budget_model.dart';
import '../theme/app_theme.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Budgets')),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          final monthBudgets = provider.budgets.where((b) => b.month == currentMonth).toList();

          if (monthBudgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No budgets set for this month.'),
                  ElevatedButton(
                    onPressed: () => _showAddBudgetDialog(context),
                    child: const Text('Set Budget'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: monthBudgets.length,
            itemBuilder: (context, index) {
              final budget = monthBudgets[index];
              final category = provider.categories.firstWhere((c) => c.id == budget.categoryId);
              final spent = provider.getSpentByCategory(budget.categoryId, currentMonth);
              final progress = (spent / budget.limitAmount).clamp(0.0, 1.0);
              final isOver = spent > budget.limitAmount;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category.name, style: Theme.of(context).textTheme.titleLarge),
                          Text('\$${spent.toStringAsFixed(2)} / \$${budget.limitAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        color: isOver ? Colors.red : AppTheme.secondaryColor,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      if (isOver) ...[
                        const SizedBox(height: 8),
                        const Text('Warning: Budget exceeded!', style: TextStyle(color: Colors.red, fontSize: 12)),
                      ] else if (progress > 0.8) ...[
                        const SizedBox(height: 8),
                        const Text('Warning: Almost at limit!', style: TextStyle(color: Colors.orange, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final amountController = TextEditingController();
    int? selectedCategoryId;
    final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Set Category Budget', style: Theme.of(context).textTheme.titleLarge),
            Consumer<FinanceProvider>(
              builder: (context, provider, child) => DropdownButtonFormField<int>(
                hint: const Text('Category'),
                value: selectedCategoryId,
                items: provider.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (val) => selectedCategoryId = val,
              ),
            ),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Limit Amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty && selectedCategoryId != null) {
                  Provider.of<FinanceProvider>(context, listen: false).addBudget(Budget(
                    categoryId: selectedCategoryId!,
                    limitAmount: double.parse(amountController.text),
                    month: currentMonth,
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
    );
  }
}
