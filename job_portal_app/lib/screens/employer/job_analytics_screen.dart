import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class JobAnalyticsScreen extends StatefulWidget {
  const JobAnalyticsScreen({super.key});

  @override
  State<JobAnalyticsScreen> createState() => _JobAnalyticsScreenState();
}

class _JobAnalyticsScreenState extends State<JobAnalyticsScreen> {
  List<Map<String, dynamic>> _jobStats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      final profile = await SupabaseService.getProfile(user!.id);
      final companyId = profile?['company_id'];
      
      if (companyId != null) {
        final jobs = await SupabaseService.client
            .from('jobs')
            .select('title, created_at, applications(count)')
            .eq('company_id', companyId);
            
        setState(() => _jobStats = List<Map<String, dynamic>>.from(jobs));
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Analytics')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _jobStats.length,
              itemBuilder: (context, index) {
                final stat = _jobStats[index];
                final appCount = (stat['applications'] as List).isNotEmpty 
                    ? stat['applications'][0]['count'] 
                    : 0;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(stat['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Posted on: ${stat['created_at'].toString().split('T')[0]}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$appCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.primaryColor)),
                        const Text('Apps', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
