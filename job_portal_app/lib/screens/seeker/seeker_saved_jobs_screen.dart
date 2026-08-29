import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import '../../widgets/job_card.dart';
import 'job_details_screen.dart';

class SeekerSavedJobsScreen extends StatefulWidget {
  const SeekerSavedJobsScreen({super.key});

  @override
  State<SeekerSavedJobsScreen> createState() => _SeekerSavedJobsScreenState();
}

class _SeekerSavedJobsScreenState extends State<SeekerSavedJobsScreen> {
  List<Map<String, dynamic>> _savedJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  Future<void> _loadSavedJobs() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user != null) {
        final saved = await SupabaseService.getSavedJobs(user.id);
        setState(() => _savedJobs = saved
            .where((e) => e['jobs'] != null)
            .map((e) => e['jobs'] as Map<String, dynamic>)
            .toList());
      }
    } catch (e) {
      print('Error loading saved jobs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Jobs')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedJobs.isEmpty
              ? const Center(child: Text('No saved jobs yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _savedJobs.length,
                  itemBuilder: (context, index) => JobCard(
                    job: _savedJobs[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsScreen(job: _savedJobs[index]),
                      ),
                    ),
                  ),
                ),
    );
  }
}
