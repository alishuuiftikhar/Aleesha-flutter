import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/team_provider.dart';
import '../../providers/submission_provider.dart';
import '../../widgets/submission_tile.dart';
import '../../widgets/common/empty_state.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final team = context.read<TeamProvider>().myTeam;
      if (team != null) context.read<SubmissionProvider>().load(team.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final submissions = context.watch<SubmissionProvider>().submissions;
    final isLoading = context.watch<SubmissionProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.submissionUpload),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.submissionUpload),
        icon: const Icon(Icons.add),
        label: const Text('New Submission'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : submissions.isEmpty
              ? const EmptyState(
                  icon: Icons.upload_file_outlined,
                  title: 'No submissions yet',
                  message: 'Upload your proposal, SRS, design, progress, or final report.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: submissions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => SubmissionTile(submission: submissions[index]),
                ),
    );
  }
}
