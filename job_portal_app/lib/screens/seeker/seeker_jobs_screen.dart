import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import '../../widgets/job_card.dart';
import 'job_details_screen.dart';

class SeekerJobsScreen extends StatefulWidget {
  const SeekerJobsScreen({super.key});

  @override
  State<SeekerJobsScreen> createState() => _SeekerJobsScreenState();
}

class _SeekerJobsScreenState extends State<SeekerJobsScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs({String? searchQuery}) async {
    setState(() => _isLoading = true);
    try {
      final jobs = await SupabaseService.getJobs(searchQuery: searchQuery);
      setState(() => _jobs = jobs);
    } catch (e) {
      print('Error loading jobs: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Jobs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Show filters
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (val) => _loadJobs(searchQuery: val),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
              ? const Center(child: Text('No jobs found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  itemCount: _jobs.length,
                  itemBuilder: (context, index) => JobCard(
                    job: _jobs[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsScreen(job: _jobs[index]),
                      ),
                    ),
                  ),
                ),
    );
  }
}
