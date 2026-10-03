import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/membership.dart';
import '../../../core/theme/app_theme.dart';
import 'coaches_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = context.read<SupabaseService>();
    final user = supabaseService.currentUser;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Welcome, ${user?.email?.split('@')[0] ?? 'Member'}'),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.sports_baseball, size: 80, color: Colors.white24),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMembershipCard(context),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                Text(
                  'Upcoming Classes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildUpcomingClasses(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipCard(BuildContext context) {
    final supabaseService = context.read<SupabaseService>();
    return FutureBuilder<Membership?>(
      future: supabaseService.getUserMembership(supabaseService.currentUser?.id ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(child: SizedBox(height: 150, child: Center(child: CircularProgressIndicator())));
        }

        final membership = snapshot.data;
        if (membership == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('No Active Membership', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Join a plan to unlock all features of the sports club.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // We are inside a Tab, so we might need a different way to switch tabs
                      // But for now, just a snackbar or simple navigation
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Go to Plans tab to join!')));
                    },
                    child: const Text('View Plans'),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      membership.status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('PREMIUM MEMBER', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text(
                'Expires: ${membership.endDate.day}/${membership.endDate.month}/${membership.endDate.year}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.calendar_today, 'label': 'Book Class', 'color': AppColors.accent},
      {'icon': Icons.people, 'label': 'Coaches', 'color': AppColors.secondary},
      {'icon': Icons.location_on, 'label': 'Facilities', 'color': AppColors.success},
      {'icon': Icons.history, 'label': 'History', 'color': AppColors.warning},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (actions[index]['label'] == 'Coaches') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CoachesScreen()));
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: (actions[index]['color'] as Color).withOpacity(0.1),
                radius: 28,
                child: Icon(actions[index]['icon'] as IconData, color: actions[index]['color'] as Color),
              ),
              const SizedBox(height: 8),
              Text(actions[index]['label'] as String, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpcomingClasses() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.secondary.withOpacity(0.1),
              child: const Icon(Icons.fitness_center, color: AppColors.secondary),
            ),
            title: const Text('HIIT Training', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Today at 6:00 PM • Coach Alex'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
