import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/membership_plan.dart';
import '../../../core/theme/app_theme.dart';

class MembershipPlansScreen extends StatelessWidget {
  const MembershipPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = context.read<SupabaseService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Membership Plans')),
      body: FutureBuilder<List<MembershipPlan>>(
        future: supabaseService.getMembershipPlans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final plans = snapshot.data ?? [];
          if (plans.isEmpty) {
            return const Center(child: Text('No plans available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plan.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          Text(
                            '\$${plan.price.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '/${plan.durationDays} days',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(plan.description),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      ...plan.benefits.map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                                const SizedBox(width: 8),
                                Text(benefit),
                              ],
                            ),
                          )),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _joinPlan(context, plan),
                          child: const Text('Join Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _joinPlan(BuildContext context, MembershipPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Membership'),
        content: Text('Do you want to join the ${plan.name} plan for \$${plan.price}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Handle real payment / membership creation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membership request submitted!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
