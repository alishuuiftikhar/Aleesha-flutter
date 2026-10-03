import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../models/project_idea_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/team_provider.dart';
import '../../providers/supervision_provider.dart';
import '../../widgets/common/app_button.dart';

class IdeaDetailScreen extends StatelessWidget {
  final ProjectIdea idea;
  const IdeaDetailScreen({super.key, required this.idea});

  Future<void> _applyOrRequestSupervision(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;

    if (!auth.isLoggedIn) {
      Navigator.of(context).pushNamed(AppRoutes.login);
      return;
    }

    final teamProvider = context.read<TeamProvider>();
    await teamProvider.loadMyTeam(user.id);
    final team = teamProvider.myTeam;

    if (team == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a team first before applying to an idea.')),
      );
      Navigator.of(context).pushNamed(AppRoutes.createTeam);
      return;
    }

    await context.read<SupervisionProvider>().sendRequest(
          team: team,
          supervisorId: idea.supervisorId,
          supervisorName: idea.supervisorName,
          projectTitle: idea.title,
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Supervision request sent to ${idea.supervisorName}.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(title: const Text('Idea Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _pill(idea.domain, AppColors.primary),
                const SizedBox(width: 6),
                _pill(idea.difficulty, AppColors.accent),
                const Spacer(),
                _pill(idea.status, idea.isOpen ? AppColors.success : AppColors.danger),
              ],
            ),
            const SizedBox(height: 14),
            Text(idea.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Supervised by ${idea.supervisorName}', style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.groups_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Max teams: ${idea.maxTeams} · Assigned: ${idea.teamsAssigned}',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.event_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Posted ${idea.postedOn.day}/${idea.postedOn.month}/${idea.postedOn.year}',
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Project Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(idea.description, style: const TextStyle(height: 1.5, color: AppColors.textPrimary)),
            const SizedBox(height: 18),
            const Text('Required Skills & Tech Stack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: idea.techStack
                  .map((t) => Chip(label: Text(t), backgroundColor: AppColors.background))
                  .toList(),
            ),
            const SizedBox(height: 28),
            AppButton(
              label: isLoggedIn ? 'Apply / Request Supervision' : 'Login to Apply',
              onPressed: idea.isOpen ? () => _applyOrRequestSupervision(context) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}
