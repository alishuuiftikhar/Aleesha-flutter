import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/reminder.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllReminders();
    if (mounted) {
      setState(() {
        _reminders = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleCompleted(Reminder reminder) async {
    await DatabaseHelper.instance.toggleReminderCompleted(reminder);
    _loadReminders();
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Delete Reminder',
      content: 'Are you sure you want to delete "${reminder.title}"?',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteReminder(reminder.id!);
      _loadReminders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder deleted'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  void _showAddReminderDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String reminderTime = '05:00 PM';
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add New Reminder', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Reminder Title *'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description / Location'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'General', child: Text('General')),
                      DropdownMenuItem(value: 'Visitor', child: Text('Visitor Arrival')),
                      DropdownMenuItem(value: 'Delivery', child: Text('Delivery Collection')),
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance Service')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.calendar_today, color: AppTheme.primary),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Time', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                    subtitle: Text(reminderTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.access_time, color: AppTheme.primary),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 17, minute: 0),
                      );
                      if (picked != null) {
                        final now = DateTime.now();
                        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                        setDialogState(() => reminderTime = DateFormat('hh:mm a').format(dt));
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;
                  final newRem = Reminder(
                    title: titleController.text.trim(),
                    description: descController.text.trim(),
                    reminderDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                    reminderTime: reminderTime,
                    category: category,
                  );
                  await DatabaseHelper.instance.addReminder(newRem);
                  Navigator.pop(ctx);
                  _loadReminders();
                },
                child: const Text('Add Reminder'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Reminders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _reminders.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.notifications_none_rounded,
                  title: 'No Reminders Set',
                  description: 'Keep track of visitor expected times, package pickups, and maintenance appointments.',
                  actionLabel: 'Add Reminder',
                  onActionPressed: _showAddReminderDialog,
                )
              : RefreshIndicator(
                  onRefresh: _loadReminders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final rem = _reminders[index];
                      return CustomCard(
                        child: Row(
                          children: [
                            Checkbox(
                              value: rem.isCompleted,
                              activeColor: AppTheme.success,
                              onChanged: (_) => _toggleCompleted(rem),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rem.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: rem.isCompleted ? TextDecoration.lineThrough : null,
                                      color: rem.isCompleted ? AppTheme.textMuted : AppTheme.textDark,
                                    ),
                                  ),
                                  if (rem.description.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      rem.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textMuted,
                                        decoration: rem.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 12, color: AppTheme.accent),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${rem.reminderDate} at ${rem.reminderTime} • ${rem.category}',
                                        style: const TextStyle(fontSize: 12, color: AppTheme.accent, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                              onPressed: () => _deleteReminder(rem),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderDialog,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Add Reminder'),
      ),
    );
  }
}
