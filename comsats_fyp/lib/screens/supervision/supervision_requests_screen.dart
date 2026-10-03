import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/supervision_provider.dart';
import '../../widgets/common/empty_state.dart';

class SupervisionRequestsScreen extends StatelessWidget {
  const SupervisionRequestsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final provider = context.watch<SupervisionProvider>();
    final isSupervisor = user?.role == UserRole.supervisor;

    return Scaffold(
      appBar: AppBar(title: const Text('Supervision Requests')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.requests.isEmpty
              ? const EmptyState(
                  icon: Icons.pending_actions_outlined,
                  title: 'No requests',
                  message: 'Supervision requests will appear here once sent.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final req = provider.requests[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(req.projectTitle,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _statusColor(req.status).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(req.status.toUpperCase(),
                                      style: TextStyle(color: _statusColor(req.status), fontSize: 10.5, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Team: ${req.teamName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            Text('Supervisor: ${req.supervisorName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            if (isSupervisor && req.status == 'pending') ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => provider.respond(req.id, false),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => provider.respond(req.id, true),
                                      child: const Text('Approve'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
