import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  int _activeJobs = 0;
  int _totalApplications = 0;
  List<Map<String, dynamic>> _recentApplications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) return;
      
      final profile = await SupabaseService.getProfile(user.id);
      final companyId = profile?['company_id'];
      
      if (companyId != null) {
        // Fetch jobs and applications in parallel
        final results = await Future.wait([
          SupabaseService.getEmployerJobs(companyId.toString()),
          SupabaseService.getEmployerAllApplications(companyId.toString()),
        ]);
        
        final List<Map<String, dynamic>> jobs = List<Map<String, dynamic>>.from(results[0]);
        final List<Map<String, dynamic>> apps = List<Map<String, dynamic>>.from(results[1]);
        
        setState(() {
          _activeJobs = jobs.length; // Counting all jobs in "Manage Jobs"
          _totalApplications = apps.length;
          _recentApplications = apps;
        });
      }
    } catch (e) {
      debugPrint('Dashboard Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String applicationId, String newStatus) async {
    try {
      await SupabaseService.updateApplicationStatus(applicationId, newStatus);
      _loadStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employer Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildStatCard('Active Jobs', _activeJobs.toString(), Icons.work, Colors.blue),
                        const SizedBox(width: 16),
                        _buildStatCard('Total Apps', _totalApplications.toString(), Icons.people, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Recent Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (_recentApplications.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('No applications received yet.'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentApplications.length,
                        itemBuilder: (context, index) {
                          final app = _recentApplications[index];
                          final seeker = app['profiles'];
                          final job = app['jobs'];
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const CircleAvatar(child: Icon(Icons.person)),
                              title: Text(seeker?['full_name'] ?? 'Candidate'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Applied for: ${job?['title'] ?? 'Job'}'),
                                  Text('Status: ${app['status']}', style: TextStyle(color: _getStatusColor(app['status']))),
                                ],
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
                                // Show cover letter
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.all(AppConstants.padding),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(seeker?['full_name'] ?? 'Candidate', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 8),
                                        if (seeker?['phone'] != null)
                                          Text('Phone: ${seeker!['phone']}', style: const TextStyle(color: Colors.grey)),
                                        const SizedBox(height: 16),
                                        const Text('Cover Letter:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(app['cover_letter'] ?? 'No cover letter provided.'),
                                        if (seeker?['bio'] != null && seeker!['bio'].isNotEmpty) ...[
                                          const SizedBox(height: 16),
                                          const Text('Candidate Bio:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(seeker['bio']),
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
                  ],
                ),
              ),
            ),
    );
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
