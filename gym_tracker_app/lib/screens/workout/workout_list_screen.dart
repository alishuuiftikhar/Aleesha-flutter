import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../services/database_service.dart';
import '../../models/workout.dart';
import 'create_workout_screen.dart';
import 'workout_execution_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Workout>> _workoutsFuture;

  @override
  void initState() {
    super.initState();
    _refreshWorkouts();
  }

  void _refreshWorkouts() {
    setState(() {
      _workoutsFuture = _dbService.getWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WORKOUT PLANS', style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateWorkoutScreen()));
              _refreshWorkouts();
            },
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
          ),
        ],
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }
          final workouts = snapshot.data ?? [];
          if (workouts.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return _buildWorkoutCard(workout);
            },
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(workout.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(workout.description ?? 'No description', style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.secondaryText),
          onPressed: () => _confirmDelete(workout),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutExecutionScreen(workout: workout))),
      ),
    );
  }

  Future<void> _confirmDelete(Workout workout) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Delete Workout?'),
        content: const Text('This will permanently remove this plan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _dbService.deleteWorkout(workout.id);
      _refreshWorkouts();
    }
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 60),
          const SizedBox(height: 20),
          Text('DATABASE TABLE MISSING', style: GoogleFonts.bebasNeue(fontSize: 22, color: AppColors.error)),
          const SizedBox(height: 10),
          const Text(
            'The "workouts" table was not found in your Supabase. Please run the SQL script in Supabase SQL Editor.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.secondaryText),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _refreshWorkouts, child: const Text('RETRY')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center, size: 80, color: AppColors.divider),
          const SizedBox(height: 20),
          Text('NO PLANS YET', style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.secondaryText)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateWorkoutScreen()));
              _refreshWorkouts();
            },
            child: const Text('CREATE FIRST WORKOUT'),
          ),
        ],
      ),
    );
  }
}
