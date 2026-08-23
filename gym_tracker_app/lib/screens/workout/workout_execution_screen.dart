import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/workout.dart';
import '../../models/workout_exercise.dart';
import '../../services/database_service.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutExecutionScreen({super.key, required this.workout});

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<WorkoutExercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _dbService.getWorkoutExercises(widget.workout.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name.toUpperCase()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FINISH', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: FutureBuilder<List<WorkoutExercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final exercises = snapshot.data ?? [];
          if (exercises.isEmpty) {
            return const Center(child: Text('No exercises in this workout'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exercise ID: ${ex.exerciseId}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMetric('SETS', ex.sets.toString())),
                          Expanded(child: _buildMetric('REPS', ex.reps.toString())),
                          Expanded(child: _buildMetric('WEIGHT', '${ex.weight} kg')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.divider,
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        child: const Text('LOG SET'),
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

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
