import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/supabase_service.dart';
import '../models/complaint_model.dart';
import '../models/update_model.dart';
import '../theme/app_colors.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailsScreen({super.key, required this.complaintId});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<Complaint> _complaintFuture;
  late Future<List<ComplaintUpdate>> _updatesFuture;

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

  Future<void> _cancelComplaint() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Complaint'),
        content: const Text('Are you sure you want to cancel this complaint?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabaseService.updateComplaintStatus(
          widget.complaintId,
          ComplaintStatus.closed,
          'Complaint cancelled by user.',
        );
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(complaint.status),
                    Text(
                      DateFormat('MMM d, yyyy').format(complaint.createdAt),
                      style: const TextStyle(color: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  complaint.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(complaint.categoryName ?? 'General', style: const TextStyle(color: AppColors.secondary)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Priority: ${complaint.priority}', style: const TextStyle(color: AppColors.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(complaint.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                if (complaint.imageUrl != null) ...[
                  const Text('Attachment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: complaint.imageUrl!,
                      placeholder: (context, url) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                const Divider(),
                const SizedBox(height: 16),
                const Text('Status Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                FutureBuilder<List<ComplaintUpdate>>(
                  future: _updatesFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final updates = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: updates.length,
                      itemBuilder: (context, index) {
                        final update = updates[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                                  if (index != updates.length - 1)
                                    Container(width: 2, height: 40, color: AppColors.primary.withOpacity(0.3)),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(update.status, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(DateFormat('MMM d, HH:mm').format(update.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                                      ],
                                    ),
                                    Text(update.message, style: TextStyle(color: AppColors.text.withOpacity(0.8))),
                                    if (update.updaterName != null)
                                      Text('By: ${update.updaterName}', style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                if (complaint.status == ComplaintStatus.pending)
                  OutlinedButton(
                    onPressed: _cancelComplaint,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Cancel Complaint'),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(ComplaintStatus status) {
    Color color;
    switch (status) {
      case ComplaintStatus.pending: color = Colors.orange; break;
      case ComplaintStatus.assigned: color = Colors.blue; break;
      case ComplaintStatus.inProgress: color = Colors.purple; break;
      case ComplaintStatus.resolved: color = Colors.green; break;
      case ComplaintStatus.closed: color = Colors.grey; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
