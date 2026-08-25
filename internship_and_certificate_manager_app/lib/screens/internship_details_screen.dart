import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/internship_model.dart';
import '../models/note_model.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';
import 'add_edit_internship_screen.dart';

class InternshipDetailsScreen extends StatefulWidget {
  final Internship internship;

  const InternshipDetailsScreen({super.key, required this.internship});

  @override
  State<InternshipDetailsScreen> createState() => _InternshipDetailsScreenState();
}

class _InternshipDetailsScreenState extends State<InternshipDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditInternshipScreen(internship: widget.internship),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final company = provider.getCompanyById(widget.internship.companyId);
          final supervisor = widget.internship.supervisorId != null
              ? provider.getSupervisorById(widget.internship.supervisorId!)
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(company),
                const SizedBox(height: 32),
                _buildProgressSection(),
                const SizedBox(height: 32),
                _buildDetailsCard(company, supervisor),
                const SizedBox(height: 32),
                _buildNotesSection(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(dynamic company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.internship.position,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        Text(
          company?.name ?? 'Unknown Company',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final progress = widget.internship.calculateProgress();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Internship Progress', style: Theme.of(context).textTheme.titleLarge),
            Text('${(progress * 100).toInt()}%',
                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: AppColors.cardBackground,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('MMM dd, yyyy').format(widget.internship.startDate),
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
            Text(DateFormat('MMM dd, yyyy').format(widget.internship.endDate),
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsCard(dynamic company, dynamic supervisor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDetailRow(Icons.business, 'Department', widget.internship.department),
            const Divider(height: 32, color: AppColors.secondaryBackground),
            _buildDetailRow(Icons.timer, 'Duration', widget.internship.duration),
            const Divider(height: 32, color: AppColors.secondaryBackground),
            _buildDetailRow(Icons.person, 'Supervisor', supervisor?.name ?? 'Not assigned'),
            if (supervisor?.contact != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow(Icons.contact_phone, 'Contact', supervisor!.contact!),
            ],
            const Divider(height: 32, color: AppColors.secondaryBackground),
            _buildDetailRow(Icons.info_outline, 'Status', widget.internship.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryText),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection(AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Internship Notes', style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              icon: const Icon(Icons.add_comment_outlined, color: AppColors.accent),
              onPressed: () => _showAddNoteDialog(provider),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<InternshipNote>>(
          future: provider.getNotesForInternship(widget.internship.id!),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No notes added yet', style: TextStyle(color: AppColors.secondaryText)),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Card(
                  color: AppColors.secondaryBackground,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(note.content),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy - HH:mm').format(note.createdAt),
                      style: const TextStyle(fontSize: 10),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                      onPressed: () => provider.deleteNote(note.id!).then((_) => setState(() {})),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showAddNoteDialog(AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Enter your note here...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                final note = InternshipNote(
                  internshipId: widget.internship.id!,
                  content: _noteController.text,
                  createdAt: DateTime.now(),
                );
                provider.addNote(note).then((_) {
                  _noteController.clear();
                  Navigator.pop(context);
                  setState(() {});
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Internship?'),
        content: const Text('This action cannot be undone. Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false)
                  .deleteInternship(widget.internship.id!)
                  .then((_) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to list
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
