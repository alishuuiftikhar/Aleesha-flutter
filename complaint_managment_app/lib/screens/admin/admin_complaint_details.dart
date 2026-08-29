import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../services/auth_provider.dart';
import '../../models/complaint_model.dart';
import '../../models/update_model.dart';
import '../../theme/app_colors.dart';

class AdminComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;

  const AdminComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<AdminComplaintDetailsScreen> createState() => _AdminComplaintDetailsScreenState();
}

class _AdminComplaintDetailsScreenState extends State<AdminComplaintDetailsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<Complaint> _complaintFuture;
  late Future<List<ComplaintUpdate>> _updatesFuture;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _complaintFuture = _supabaseService.getComplaintDetails(widget.complaintId);
      _updatesFuture = _supabaseService.getComplaintUpdates(widget.complaintId);
    });
  }

  Future<void> _updateStatus(ComplaintStatus status) async {
    final message = _messageController.text.trim();
    if (message.isEmpty && status != ComplaintStatus.assigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a response message'), backgroundColor: AppColors.error),
      );
      return;
    }

    try {
      await _supabaseService.updateComplaintStatus(
        widget.complaintId,
        status,
        message.isEmpty ? 'Status updated to ${status.name}' : message,
      );
      _messageController.clear();
      _refresh();
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _assignToMe() async {
    try {
      final adminId = context.read<AuthProvider>().currentUser!.id;
      await _supabaseService.assignComplaint(widget.complaintId, adminId);
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Complaint')),
      body: FutureBuilder<Complaint>(
        future: _complaintFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final complaint = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(complaint),
                const Divider(height: 40),
                const Text('Admin Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 16),
                if (complaint.status == ComplaintStatus.pending)
                  ElevatedButton.icon(
                    onPressed: _assignToMe,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Assign to Me'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Response / Update Message',
                    hintText: 'Enter a message for the user...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(ComplaintStatus.inProgress),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        child: const Text('In Progress'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(ComplaintStatus.resolved),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Resolve'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _updateStatus(ComplaintStatus.closed),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Close Complaint'),
                ),
                const SizedBox(height: 32),
                const Text('Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTimeline(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(Complaint complaint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('From: ${complaint.userName ?? 'Unknown User'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(DateFormat('MMM d, HH:mm').format(complaint.createdAt)),
          ],
        ),
        const SizedBox(height: 8),
        Text(complaint.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 12),
        Text(complaint.description, style: const TextStyle(fontSize: 16)),
        if (complaint.imageUrl != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(imageUrl: complaint.imageUrl!),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeline() {
    return FutureBuilder<List<ComplaintUpdate>>(
      future: _updatesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final updates = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: updates.length,
          itemBuilder: (context, index) {
            final update = updates[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, size: 20),
              title: Text(update.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(update.message, style: const TextStyle(fontSize: 13)),
              trailing: Text(DateFormat('MMM d').format(update.createdAt), style: const TextStyle(fontSize: 10)),
            );
          },
        );
      },
    );
  }
}
