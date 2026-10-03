import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../models/moodboard.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../widgets/inspiration_card.dart';

class MoodboardDetailScreen extends StatefulWidget {
  final Moodboard moodboard;

  const MoodboardDetailScreen({super.key, required this.moodboard});

  @override
  State<MoodboardDetailScreen> createState() => _MoodboardDetailScreenState();
}

class _MoodboardDetailScreenState extends State<MoodboardDetailScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.moodboard.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final items = provider.getMoodboardItems(widget.moodboard.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moodboard.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () => _showNotesDialog(context, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.moodboard.notes.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(widget.moodboard.notes),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No items in this moodboard'))
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            InspirationCard(item: items[index]),
                            Positioned(
                              top: 5,
                              left: 5,
                              child: IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  provider.removeFromMoodboard(widget.moodboard.id, items[index].id);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showNotesDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Moodboard Notes'),
        content: TextField(
          controller: _notesController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Add your creative thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateMoodboardNotes(widget.moodboard.id, _notesController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
