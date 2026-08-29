import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class EmployerJobApplicationsScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const EmployerJobApplicationsScreen({super.key, required this.jobId, required this.jobTitle});

  @override
  State<EmployerJobApplicationsScreen> createState() => _EmployerJobApplicationsScreenState();
}

class _EmployerJobApplicationsScreenState extends State<EmployerJobApplicationsScreen> {
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final apps = await SupabaseService.getJobApplications(widget.jobId);
      setState(() => _applications = apps);
    } catch (e) {
      print('Error loading applications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String applicationId, String newStatus) async {
    try {
      await SupabaseService.updateApplicationStatus(applicationId, newStatus);
      _loadApplications();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'reviewed': return Colors.blue;
      case 'shortlisted': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Applications: ${widget.jobTitle}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('No applications yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _applications.length,
                  itemBuilder: (context, index) {
                    final app = _applications[index];
                    final profile = app['profiles'];
                    
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(profile['full_name'] ?? 'Candidate'),
                        subtitle: Text(
                          'Status: ${app['status']}',
                          style: TextStyle(color: _getStatusColor(app['status']), fontWeight: FontWeight.bold),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (val) => _updateStatus(app['id'].toString(), val),
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'reviewed', child: Text('Reviewed')),
                            const PopupMenuItem(value: 'shortlisted', child: Text('Shortlist')),
                            const PopupMenuItem(value: 'rejected', child: Text('Reject')),
                          ],
                        ),
                        onTap: () {
                          // Show candidate details and cover letter
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(AppConstants.padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(profile['full_name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  if (profile['phone'] != null)
                                    Text('Phone: ${profile['phone']}', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 16),
                                  const Text('Cover Letter:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(app['cover_letter'] ?? 'No cover letter provided.'),
                                  if (profile['bio'] != null && profile['bio'].isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    const Text('Candidate Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(profile['bio']),
                                  ],
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {}, // Download resume
                                    child: const Text('View Resume'),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
