import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/exercise.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EXERCISE DETAILS')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              color: AppColors.cardBackground,
              child: exercise.imageUrl != null
                  ? Image.network(exercise.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 100, color: AppColors.divider),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildBadge(exercise.category),
                      const SizedBox(width: 8),
                      if (exercise.bodyPart != null) _buildBadge(exercise.bodyPart!),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    exercise.description ?? 'No instructions available for this exercise.',
                    style: const TextStyle(color: AppColors.secondaryText, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
