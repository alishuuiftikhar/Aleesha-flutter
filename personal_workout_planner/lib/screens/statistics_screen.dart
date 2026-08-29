import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';
import '../widgets/section_header.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(provider),
                const SizedBox(height: 30),
                const SectionHeader(title: 'Completion Rate'),
                const SizedBox(height: 16),
                _buildCompletionCard(provider),
                const SizedBox(height: 30),
                const SectionHeader(title: 'Recent Activity'),
                const SizedBox(height: 16),
                _buildHistoryList(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(WorkoutProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Total Workouts',
          value: provider.totalWorkouts.toString(),
          icon: Icons.fitness_center,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'Weekly Count',
          value: provider.weeklyWorkouts.toString(),
          icon: Icons.calendar_today,
          color: AppColors.accent,
        ),
        _StatCard(
          title: 'Current Streak',
          value: '${provider.currentStreak} Days',
          icon: Icons.local_fire_department,
          color: AppColors.warning,
        ),
        _StatCard(
          title: 'Total Time',
          value: '${(provider.history.fold(0, (sum, s) => sum + s.durationSeconds) / 60).round()}m',
          icon: Icons.timer,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildCompletionCard(WorkoutProvider provider) {
    final rate = provider.totalWorkouts > 0 ? (provider.weeklyWorkouts / 7).clamp(0.0, 1.0) : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: rate,
            center: Text(
              "${(rate * 100).toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.cardBackground,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'You are doing great! Keep up the consistency to reach your fitness goals.',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(WorkoutProvider provider) {
    if (provider.history.isEmpty) {
      return const Center(
        child: Text('No workout history yet.', style: TextStyle(color: AppColors.secondaryText)),
      );
    }

    final history = [...provider.history]..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final session = history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.workoutTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(session.date),
                      style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(session.durationSeconds / 60).round()} min',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${session.caloriesBurned} kcal',
                    style: const TextStyle(color: AppColors.accent, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
            ],
          ),
        ],
      ),
    );
  }
}
