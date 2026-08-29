import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class SeekerApplicationsScreen extends StatefulWidget {
  const SeekerApplicationsScreen({super.key});

  @override
  State<SeekerApplicationsScreen> createState() => _SeekerApplicationsScreenState();
}

class _SeekerApplicationsScreenState extends State<SeekerApplicationsScreen> {
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
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final apps = await SupabaseService.getMyApplications(user.id);
        setState(() => _applications = apps);
      }
    } catch (e) {
      print('Error loading applications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('You haven\'t applied to any jobs yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _applications.length,
                  itemBuilder: (context, index) {
                    final app = _applications[index];
                    final job = app['jobs'] as Map<String, dynamic>? ?? {};
                    final company = job['companies'] as Map<String, dynamic>? ?? {};
                    final status = app['status'];

                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: company['logo_url'] != null
                              ? Image.network(company['logo_url'], errorBuilder: (_, __, ___) => const Icon(Icons.business))
                              : const Icon(Icons.business),
                        ),
                        title: Text(job['title'] ?? 'Job Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(company['name'] ?? 'Company'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status?.toString()).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (status?.toString() ?? 'PENDING').toUpperCase(),
                            style: TextStyle(fontSize: 10, color: _getStatusColor(status?.toString()), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'shortlisted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
