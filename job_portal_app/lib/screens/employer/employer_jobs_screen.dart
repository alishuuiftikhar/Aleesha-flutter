import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import 'employer_create_job_screen.dart';
import 'employer_edit_job_screen.dart';
import 'employer_job_applications_screen.dart';

class EmployerJobsScreen extends StatefulWidget {
  const EmployerJobsScreen({super.key});

  @override
  State<EmployerJobsScreen> createState() => _EmployerJobsScreenState();
}

class _EmployerJobsScreenState extends State<EmployerJobsScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final profile = await SupabaseService.getProfile(user.id);
        final companyId = profile?['company_id'];
        
        if (companyId != null) {
          final jobs = await SupabaseService.getEmployerJobs(companyId.toString());
          setState(() => _jobs = jobs);
        } else {
          // If no company yet, list is just empty, no error needed
          setState(() => _jobs = []);
        }
      }
    } catch (e) {
      print('Error loading employer jobs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Jobs')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
              ? const Center(child: Text('No jobs posted yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _jobs.length,
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    return Card(
                      child: ListTile(
                        title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${job['job_type']} • ${job['location']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppConstants.primaryColor),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EmployerEditJobScreen(job: job)),
                                );
                                if (result == true) _loadJobs();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(job['id'].toString()),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmployerJobApplicationsScreen(
                                jobId: job['id'].toString(),
                                jobTitle: job['title'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployerCreateJobScreen()),
          );
          if (result == true) _loadJobs();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(String jobId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job posting?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SupabaseService.deleteJob(jobId);
        _loadJobs();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}
