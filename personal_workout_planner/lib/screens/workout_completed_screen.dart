import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../utils/constants.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  const WorkoutCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final workout = args['workout'] as Workout;
    final duration = args['duration'] as int;
    final calories = (duration / 60 * 7).toInt();

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.padding),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.mainBackground, AppColors.secondaryBackground],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(Icons.stars, size: 100, color: AppColors.accent),
            const SizedBox(height: 24),
            const Text(
              'CONGRATULATIONS!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const Text(
              'Workout Completed',
              style: TextStyle(fontSize: 18, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem('TIME', '${(duration / 60).round()}m'),
                _buildSummaryItem('CALORIES', '$calories'),
                _buildSummaryItem('EXERCISES', '${workout.exercises.length}'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                child: const Text('BACK TO HOME'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
      ],
    );
  }
}
