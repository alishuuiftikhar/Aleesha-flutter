import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<AppNote> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNote(AppNote note) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Delete Note',
      content: 'Are you sure you want to delete note "${note.title}"?',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteNote(note.id!);
      _loadNotes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  void _showNoteDialog([AppNote? note]) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    String category = note?.category ?? 'General';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(note == null ? 'Add Personal Note' : 'Edit Note',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Note Title *'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'General', child: Text('General')),
                      DropdownMenuItem(value: 'Visitor', child: Text('Visitor')),
                      DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Content / Passcode / Code',
                      alignLabelWithHint: true,
                    ),
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
                  final timeNow = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());

                  final noteToSave = AppNote(
                    id: note?.id,
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    category: category,
                    createdAt: note?.createdAt ?? timeNow,
                  );

                  if (note == null) {
                    await DatabaseHelper.instance.addNote(noteToSave);
                  } else {
                    await DatabaseHelper.instance.updateNote(noteToSave);
                  }

                  Navigator.pop(ctx);
                  _loadNotes();
                },
                child: Text(note == null ? 'Save Note' : 'Update Note'),
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
        title: const Text('Resident Notes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _notes.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.note_alt_outlined,
                  title: 'No Notes Saved',
                  description: 'Add notes for gate passcodes, delivery codes, or visitor instructions.',
                  actionLabel: 'Add Note',
                  onActionPressed: () => _showNoteDialog(),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final item = _notes[index];
                      return CustomCard(
                        onTap: () => _showNoteDialog(item),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accent),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.content,
                              style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.createdAt,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.primary),
                                      onPressed: () => _showNoteDialog(item),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
                                      onPressed: () => _deleteNote(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteDialog(),
        icon: const Icon(Icons.note_add_rounded),
        label: const Text('Add Note'),
      ),
    );
  }
}
