import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/savings_model.dart';
import '../theme/app_theme.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings Goals')),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.savingsGoals.isEmpty) {
            return const Center(child: Text('No savings goals yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.savingsGoals.length,
            itemBuilder: (context, index) {
              final goal = provider.savingsGoals[index];
              final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

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
                          Text(goal.title, style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _showUpdateGoalDialog(context, goal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}'),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        color: AppTheme.accentColor,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 8),
                      Text('${(progress * 100).toStringAsFixed(0)}% reached', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Savings Goal', style: Theme.of(context).textTheme.titleLarge),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Goal Title')),
            TextField(controller: targetController, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && targetController.text.isNotEmpty) {
                  Provider.of<FinanceProvider>(context, listen: false).addSavingsGoal(SavingsGoal(
                    title: titleController.text,
                    targetAmount: double.parse(targetController.text),
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

  void _showUpdateGoalDialog(BuildContext context, SavingsGoal goal) {
    final currentController = TextEditingController(text: goal.currentAmount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Savings: ${goal.title}', style: Theme.of(context).textTheme.titleLarge),
            TextField(controller: currentController, decoration: const InputDecoration(labelText: 'Current Amount'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<FinanceProvider>(context, listen: false).updateSavingsGoal(SavingsGoal(
                      id: goal.id,
                      title: goal.title,
                      targetAmount: goal.targetAmount,
                      currentAmount: double.parse(currentController.text),
                    ));
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<FinanceProvider>(context, listen: false).deleteSavingsGoal(goal.id!);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
