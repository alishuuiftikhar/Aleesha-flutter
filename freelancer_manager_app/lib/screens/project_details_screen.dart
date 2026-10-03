import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Tasks', icon: Icon(Icons.check_circle_outline)),
            Tab(text: 'Timer', icon: Icon(Icons.timer_outlined)),
            Tab(text: 'Finances', icon: Icon(Icons.attach_money)),
            Tab(text: 'Notes', icon: Icon(Icons.note_alt_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksTab(),
          _buildTimerTab(),
          _buildFinancesTab(),
          _buildNotesTab(),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return FutureBuilder<List<Task>>(
          future: provider.getTasks(widget.project.id!),
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? [];
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddTaskDialog(context),
                child: const Icon(Icons.add),
              ),
              body: tasks.isEmpty
                ? const Center(child: Text('No tasks yet.'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return CheckboxListTile(
                        title: Text(task.title),
                        subtitle: Text(task.priority, style: TextStyle(color: _getPriorityColor(task.priority))),
                        value: task.isCompleted,
                        onChanged: (_) => provider.toggleTaskStatus(task),
                      );
                    },
                  ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      default: return Colors.green;
    }
  }

  Widget _buildTimerTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isActive = provider.activeEntry?.projectId == widget.project.id;
        final duration = isActive ? provider.currentDuration : Duration.zero;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: isActive ? () => provider.stopTimer() : () => provider.startTimer(widget.project.id!),
                icon: Icon(isActive ? Icons.stop : Icons.play_arrow),
                label: Text(isActive ? 'Stop Timer' : 'Start Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Recent Sessions', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: FutureBuilder<List<TimeEntry>>(
                  future: provider.getTimeEntries(widget.project.id!),
                  builder: (context, snapshot) {
                    final entries = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final diff = entry.endTime?.difference(entry.startTime) ?? Duration.zero;
                        return ListTile(
                          title: Text(DateFormat.yMMMd().format(entry.startTime)),
                          trailing: Text('${diff.inMinutes} mins'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancesTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return FutureBuilder<List<Expense>>(
          future: provider.getExpenses(widget.project.id!),
          builder: (context, snapshot) {
            final expenses = snapshot.data ?? [];
            final totalExp = expenses.fold(0.0, (sum, e) => sum + e.amount);
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddExpenseDialog(context),
                child: const Icon(Icons.add),
              ),
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFinanceItem('Budget', widget.project.budget, Colors.green),
                        _buildFinanceItem('Expenses', totalExp, Colors.red),
                        _buildFinanceItem('Net', widget.project.budget - totalExp, Colors.blue),
                      ],
                    ),
                  ),
                  Expanded(
                    child: expenses.isEmpty
                      ? const Center(child: Text('No expenses recorded.'))
                      : ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final exp = expenses[index];
                            return ListTile(
                              title: Text(exp.category),
                              subtitle: Text(exp.description),
                              trailing: Text('\$${exp.amount}', style: const TextStyle(color: Colors.red)),
                            );
                          },
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFinanceItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text('\$${value.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildNotesTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return FutureBuilder<List<Note>>(
          future: provider.getNotes(widget.project.id!),
          builder: (context, snapshot) {
            final notes = snapshot.data ?? [];
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddNoteDialog(context),
                child: const Icon(Icons.add),
              ),
              body: notes.isEmpty
                ? const Center(child: Text('No notes yet.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        color: Colors.amber[100],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Expanded(child: Text(note.content, overflow: TextOverflow.fade)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            );
          },
        );
      },
    );
  }

  // Dialogs
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    String priority = 'Medium';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Task Title')),
            DropdownButtonFormField<String>(
              value: priority,
              items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => priority = val!,
              decoration: const InputDecoration(labelText: 'Priority'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).addTask(Task(
                projectId: widget.project.id!,
                title: titleController.text,
                description: '',
                priority: priority,
              ));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final amountController = TextEditingController();
    final catController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: catController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).addExpense(Expense(
                projectId: widget.project.id!,
                category: catController.text,
                amount: double.tryParse(amountController.text) ?? 0.0,
                description: descController.text,
                date: DateTime.now(),
              ));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).addNote(Note(
                projectId: widget.project.id!,
                title: titleController.text,
                content: contentController.text,
                createdAt: DateTime.now(),
              ));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
