import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';
import '../widgets/workout_card.dart';
import '../widgets/exercise_card.dart';
import '../widgets/section_header.dart';

class MyWorkoutsScreen extends StatelessWidget {
  const MyWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Fitness Library'),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Custom'),
              Tab(text: 'Workouts'),
              Tab(text: 'Exercises'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCustomWorkouts(context),
            _buildFavoriteWorkouts(context),
            _buildFavoriteExercises(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/create-workout'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCustomWorkouts(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        if (provider.customWorkouts.isEmpty) {
          return const _EmptyState(
            icon: Icons.edit_note,
            title: 'No Custom Workouts',
            subtitle: 'Create your own personalized workout plans.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.padding),
          itemCount: provider.customWorkouts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: WorkoutCard(workout: provider.customWorkouts[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoriteWorkouts(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final favs = provider.allWorkouts.where((w) => provider.isWorkoutFavorite(w.id)).toList();
        if (favs.isEmpty) {
          return const _EmptyState(
            icon: Icons.favorite_border,
            title: 'No Favorites Yet',
            subtitle: 'Workouts you favorite will appear here.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.padding),
          itemCount: favs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: WorkoutCard(workout: favs[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoriteExercises(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final favs = provider.exercises.where((e) => provider.isExerciseFavorite(e.id)).toList();
        if (favs.isEmpty) {
          return const _EmptyState(
            icon: Icons.fitness_center,
            title: 'No Exercises Saved',
            subtitle: 'Keep your favorite exercises handy.',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(AppConstants.padding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: favs.length,
          itemBuilder: (context, index) {
            return ExerciseCard(exercise: favs[index]);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.secondaryBackground),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
