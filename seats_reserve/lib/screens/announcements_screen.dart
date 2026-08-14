import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/models/announcement.dart';
import 'package:seats_reserve/theme/app_theme.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/core/constants.dart';
import 'package:seats_reserve/services/supabase_service.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.userProfile?.role == AppConstants.roleAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📢 Announcements'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddAnnouncementDialog(context),
            ),
        ],
      ),
      body: data.announcements.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.announcements.length,
              itemBuilder: (context, index) {
                final announcement = data.announcements[index];
                return _buildAnnouncementCard(context, announcement, isAdmin);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No announcements yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, Announcement announcement, bool isAdmin) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                announcement.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ),
                    if (isAdmin)
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddAnnouncementDialog(context, announcement: announcement);
                          } else if (value == 'delete') {
                            _deleteAnnouncement(context, announcement.id);
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(announcement.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context, {Announcement? announcement}) {
    final titleController = TextEditingController(text: announcement?.title);
    final descController = TextEditingController(text: announcement?.description);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement == null ? 'Create Announcement' : 'Edit Announcement'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final service = SupabaseService();
                if (announcement == null) {
                  await service.createAnnouncement(Announcement(
                    id: '',
                    title: titleController.text,
                    description: descController.text,
                    status: 'published',
                    createdAt: DateTime.now(),
                  ));
                } else {
                  await service.updateAnnouncement(announcement.id, {
                    'title': titleController.text,
                    'description': descController.text,
                  });
                }
                if (context.mounted) {
                  context.read<DataProvider>().refreshAnnouncements();
                  Navigator.pop(context);
                }
              }
            },
            child: Text(announcement == null ? 'Publish' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteAnnouncement(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SupabaseService().deleteAnnouncement(id);
      if (context.mounted) {
        context.read<DataProvider>().refreshAnnouncements();
      }
    }
  }
}
