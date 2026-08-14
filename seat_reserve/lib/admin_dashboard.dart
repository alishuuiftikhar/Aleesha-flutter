import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final reservedCount = state.allSeats.where((s) => s.isReserved).length;
    final totalSeats = state.allSeats.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher: ${state.currentUser?.fullName ?? "Dashboard"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AppState>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.displayLarge),
            Text('Manage seats and student approvals', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            _ActionCard(
              title: 'Reservation Deadline',
              subtitle: 'Current: ${state.reservationDeadline.format(context)}',
              icon: Icons.timer_outlined,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: state.reservationDeadline,
                );
                if (time != null) state.setDeadline(time);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'RESERVED',
                    value: '$reservedCount',
                    icon: Icons.event_seat,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatBox(
                    label: 'AVAILABLE',
                    value: '${totalSeats - reservedCount}',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Pending Approvals', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (state.pendingApprovals.isEmpty)
              _EmptyState(text: 'No pending student approvals')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.pendingApprovals.length,
                itemBuilder: (context, index) {
                  final user = state.pendingApprovals[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: ListTile(
                      title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.email),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () async {
                          await state.approveUser(user.id);
                        },
                        child: const Text('Approve'),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32),
            Text('Registered Students', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.approvedStudents.length,
              itemBuilder: (context, index) {
                final user = state.approvedStudents[index];
                final isReserved = state.allSeats.any((s) => s.reservedByUserId == user.id);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isReserved ? AppColors.primary : Colors.grey[200],
                      child: Icon(Icons.person, color: isReserved ? Colors.white : Colors.grey),
                    ),
                    title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(isReserved ? 'Seat Reserved' : 'No Reservation'),
                    trailing: isReserved
                        ? TextButton(
                            onPressed: () async {
                              await state.markNoShow(user.id);
                            },
                            child: const Text('Mark No-Show', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withAlpha(50)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
      ),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
    );
  }
}
