import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/team_provider.dart';
import '../../providers/submission_provider.dart';
import '../../providers/evaluation_provider.dart';
import '../../providers/supervision_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/submission_tile.dart';
import '../submissions/submissions_screen.dart';
import '../supervision/supervision_requests_screen.dart';
import '../evaluation/evaluation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;

    if (user.role == UserRole.student) {
      final teamProvider = context.read<TeamProvider>();
      await teamProvider.loadMyTeam(user.id);
      final team = teamProvider.myTeam;
      if (team != null) {
        await context.read<SubmissionProvider>().load(team.id);
        await context.read<EvaluationProvider>().load(team.id);
        await context.read<SupervisionProvider>().loadForTeam(team.id);
      }
    } else if (user.role == UserRole.supervisor) {
      await context.read<SupervisionProvider>().loadForSupervisor(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _bootstrap,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(user: user),
              const SizedBox(height: 20),
              switch (user.role) {
                UserRole.student => const _StudentDashboard(),
                UserRole.supervisor => const _SupervisorDashboard(),
                UserRole.evaluator => const _EvaluatorDashboard(),
                UserRole.subAdmin || UserRole.superAdmin => const _AdminDashboard(),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final AppUser user;
  const _WelcomeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${user.name.split(' ').first}',
              style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${user.role.label} · ${user.department}',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

class _StudentDashboard extends StatelessWidget {
  const _StudentDashboard();

  @override
  Widget build(BuildContext context) {
    final teamProvider = context.watch<TeamProvider>();
    final submissions = context.watch<SubmissionProvider>().submissions;
    final evaluations = context.watch<EvaluationProvider>().evaluations;
    final team = teamProvider.myTeam;

    if (team == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.groups_outlined, size: 40, color: AppColors.textSecondary),
              const SizedBox(height: 10),
              const Text('You have not created or joined a team yet.', textAlign: TextAlign.center),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createTeam),
                child: const Text('Create Team'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            StatCard(label: 'Team', value: team.name, icon: Icons.groups),
            StatCard(
              label: 'Supervision',
              value: team.supervisionStatus == 'approved' ? 'Approved' : 'Pending',
              icon: Icons.verified_outlined,
              color: team.supervisionStatus == 'approved' ? AppColors.success : AppColors.warning,
            ),
            StatCard(label: 'Submissions', value: '${submissions.length}', icon: Icons.upload_file_outlined),
            StatCard(label: 'Evaluations', value: '${evaluations.length}', icon: Icons.grading_outlined),
          ],
        ),
        const SizedBox(height: 22),
        SectionHeader(
          title: 'Recent Submissions',
          actionLabel: 'View all',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SubmissionsScreen()),
          ),
        ),
        const SizedBox(height: 10),
        if (submissions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No submissions yet.', style: TextStyle(color: AppColors.textSecondary)),
          )
        else
          ...submissions.take(2).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SubmissionTile(submission: s),
              )),
        const SizedBox(height: 10),
        SectionHeader(
          title: 'Supervision',
          actionLabel: 'Manage',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SupervisionRequestsScreen()),
          ),
        ),
        const SizedBox(height: 10),
        SectionHeader(
          title: 'Evaluations',
          actionLabel: 'View',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EvaluationScreen()),
          ),
        ),
      ],
    );
  }
}

class _SupervisorDashboard extends StatelessWidget {
  const _SupervisorDashboard();

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<SupervisionProvider>().requests;
    final pending = requests.where((r) => r.status == 'pending').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            StatCard(label: 'Pending Requests', value: '$pending', icon: Icons.pending_actions_outlined, color: AppColors.warning),
            const StatCard(label: 'Posted Ideas', value: '2', icon: Icons.lightbulb_outline),
          ],
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: 'Supervision Requests',
          actionLabel: 'Manage',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SupervisionRequestsScreen()),
          ),
        ),
        const SizedBox(height: 10),
        Text('$pending request(s) awaiting your approval.', style: const TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _EvaluatorDashboard extends StatelessWidget {
  const _EvaluatorDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            StatCard(label: 'Assigned Teams', value: '1', icon: Icons.groups_outlined),
            StatCard(label: 'Evaluations Done', value: '1', icon: Icons.fact_check_outlined, color: AppColors.success),
          ],
        ),
        const SizedBox(height: 20),
        SectionHeader(
          title: 'Evaluation Queue',
          actionLabel: 'Open',
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EvaluationScreen()),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Rubric-based scoring for internal/external evaluations.', style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            StatCard(label: 'Total Projects', value: '5', icon: Icons.folder_outlined),
            StatCard(label: 'Total Students', value: '1', icon: Icons.school_outlined),
            StatCard(label: 'Faculty', value: '3', icon: Icons.badge_outlined),
            StatCard(label: 'Batches', value: '1', icon: Icons.calendar_month_outlined),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Command Center Snapshot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        const Text(
          'Milestone windows: Automated · Evaluation visibility: Transparent · Feedback loop: Continuous',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
