import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';
import '../widgets/workout_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back,',
                        style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
                      ),
                      Text(
                        'Aleesha',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=aleesha'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildDailyProgress(context),
              const SizedBox(height: 30),
              const SectionHeader(title: 'Recommended for You'),
              const SizedBox(height: 16),
              Consumer<WorkoutProvider>(
                builder: (context, provider, child) {
                  final recommended = provider.allWorkouts.take(3).toList();
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommended.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: WorkoutCard(workout: recommended[index], width: 280),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const SectionHeader(title: 'Quick Categories'),
              const SizedBox(height: 16),
              _buildCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyProgress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Challenge',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Complete 3 workouts this week to reach your goal!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['Full Body', 'Upper Body', 'Lower Body', 'Core', 'Cardio', 'Flexibility'];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((cat) => _CategoryChip(label: cat)).toList(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBackground),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
