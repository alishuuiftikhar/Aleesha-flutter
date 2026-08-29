import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(workout.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(workout.image, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.mainBackground],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<WorkoutProvider>(
                builder: (context, provider, child) {
                  final isFav = provider.isWorkoutFavorite(workout.id);
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? AppColors.primary : Colors.white),
                    onPressed: () => provider.toggleFavoriteWorkout(workout.id),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildInfoChip(Icons.speed, workout.level),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.timer, '${(workout.totalDuration / 60).round()} min'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.fitness_center, '${workout.exercises.length} Ex'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.description,
                    style: const TextStyle(color: AppColors.secondaryText, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Exercises',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final workoutEx = workout.exercises[index];
                final provider = Provider.of<WorkoutProvider>(context, listen: false);
                
                // Safety check for exercise lookup
                Exercise? exercise;
                try {
                   exercise = provider.exercises.firstWhere((e) => e.id == workoutEx.exerciseId);
                } catch (e) {
                   return const ListTile(title: Text("Exercise not found"));
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          exercise.image, 
                          width: 60, 
                          height: 60, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: AppColors.cardBackground,
                            child: const Icon(Icons.fitness_center),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${workoutEx.sets} sets x ${workoutEx.reps} reps', style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.secondaryText),
                    ],
                  ),
                );
              },
              childCount: workout.exercises.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppConstants.padding),
        decoration: const BoxDecoration(
          color: AppColors.mainBackground,
          border: Border(top: BorderSide(color: AppColors.cardBackground)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/active-workout', arguments: workout),
            child: const Text('START WORKOUT'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
