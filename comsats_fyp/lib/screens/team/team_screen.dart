import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../models/team_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/team_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) context.read<TeamProvider>().loadMyTeam(user.id);
    });
  }

  void _showAddMemberSheet(BuildContext context) {
    final nameController = TextEditingController();
    final regController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add Team Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            AppTextField(label: 'Full Name', controller: nameController, prefixIcon: Icons.person_outline),
            const SizedBox(height: 12),
            AppTextField(label: 'Registration Number', controller: regController, prefixIcon: Icons.badge_outlined),
            const SizedBox(height: 18),
            AppButton(
              label: 'Add Member',
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                context.read<TeamProvider>().addMember(
                      TeamMember(
                        id: 'm${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text.trim(),
                        regNumber: regController.text.trim(),
                      ),
                    );
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = context.watch<TeamProvider>();
    final team = teamProvider.myTeam;

    return Scaffold(
      appBar: AppBar(title: const Text('My Team'), automaticallyImplyLeading: false),
      body: teamProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : team == null
              ? EmptyState(
                  icon: Icons.groups_outlined,
                  title: 'No team yet',
                  message: 'Create a team to start your FYP journey.',
                  action: AppButton(
                    label: 'Create Team',
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createTeam),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(team.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              if (team.projectTitle != null) ...[
                                Text('Project: ${team.projectTitle}', style: const TextStyle(color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                              ],
                              if (team.supervisorName != null)
                                Text('Supervisor: ${team.supervisorName} (${team.supervisionStatus})',
                                    style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: () => _showAddMemberSheet(context),
                            icon: const Icon(Icons.person_add_alt_1, size: 18),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...team.members.map((m) => Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(m.name.isNotEmpty ? m.name[0] : '?',
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                              title: Text(m.name),
                              subtitle: Text(m.regNumber),
                              trailing: m.isLeader
                                  ? const Chip(label: Text('Leader', style: TextStyle(fontSize: 11)))
                                  : null,
                            ),
                          )),
                    ],
                  ),
                ),
    );
  }
}
