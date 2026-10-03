import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/moodboard.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import 'moodboard_detail_screen.dart';

class MoodboardScreen extends StatelessWidget {
  const MoodboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final moodboards = provider.moodboards;

    return Scaffold(
      body: moodboards.isEmpty
          ? const Center(child: Text('Create your first moodboard!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: moodboards.length,
              itemBuilder: (context, index) {
                final mb = moodboards[index];
                return _buildMoodboardCard(context, mb, provider);
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_mb',
        onPressed: () => _showCreateMoodboardDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMoodboardCard(BuildContext context, Moodboard mb, AppProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(mb.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text('${mb.itemIds.length} items'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rename', child: Text('Rename')),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
          onSelected: (val) {
            if (val == 'rename') _showRenameDialog(context, mb);
            if (val == 'delete') provider.deleteMoodboard(mb.id);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoodboardDetailScreen(moodboard: mb),
            ),
          );
        },
      ),
    );
  }

  void _showCreateMoodboardDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Moodboard'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false).createMoodboard(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, Moodboard mb) {
    final controller = TextEditingController(text: mb.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Moodboard'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false).renameMoodboard(mb.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
