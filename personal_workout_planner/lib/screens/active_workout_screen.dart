import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  bool _isResting = false;
  int _timerSeconds = 0;
  Timer? _timer;
  bool _isPaused = false;
  int _totalDurationSeconds = 0;
  Timer? _totalTimer;

  @override
  void initState() {
    super.initState();
    _startTotalTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _totalTimer?.cancel();
    super.dispose();
  }

  void _startTotalTimer() {
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _totalDurationSeconds++;
        });
      }
    });
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _timerSeconds = seconds;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_timerSeconds > 0) {
            _timerSeconds--;
          } else {
            _timer?.cancel();
            if (_isResting) {
              _isResting = false;
            } else {
              _nextStep();
            }
          }
        });
      }
    });
  }

  void _nextStep() {
    final workout = ModalRoute.of(context)!.settings.arguments as Workout;
    final currentEx = workout.exercises[_currentExerciseIndex];

    if (_currentSet < currentEx.sets) {
      // Start Rest Timer
      setState(() {
        _isResting = true;
      });
      _startTimer(currentEx.restTime);
      _currentSet++;
    } else {
      // Move to next exercise
      if (_currentExerciseIndex < workout.exercises.length - 1) {
        setState(() {
          _currentExerciseIndex++;
          _currentSet = 1;
          _isResting = false;
        });
      } else {
        // Workout Finished
        _finishWorkout(workout);
      }
    }
  }

  void _prevStep() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentSet = 1;
        _isResting = false;
      });
      _timer?.cancel();
    }
  }

  void _finishWorkout(Workout workout) {
    _timer?.cancel();
    _totalTimer?.cancel();
    Provider.of<WorkoutProvider>(context, listen: false)
        .completeWorkout(workout, _totalDurationSeconds);
    Navigator.pushReplacementNamed(context, '/workout-completed', arguments: {
      'workout': workout,
      'duration': _totalDurationSeconds,
    });
  }

  @override
  Widget build(BuildContext context) {
    final workout = ModalRoute.of(context)!.settings.arguments as Workout;
    final workoutEx = workout.exercises[_currentExerciseIndex];
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    
    Exercise? exercise;
    try {
      exercise = provider.exercises.firstWhere((e) => e.id == workoutEx.exerciseId);
    } catch (e) {
      return const Scaffold(body: Center(child: Text("Exercise error")));
    }

    double progress = (_currentExerciseIndex) / workout.exercises.length;
    if (_currentExerciseIndex == workout.exercises.length - 1 && !_isResting && _currentSet == workoutEx.sets) {
        // Almost done
    }

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: Text(workout.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Column(
        children: [
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.cardBackground,
            progressColor: AppColors.primary,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: _isResting ? _buildRestUI(workoutEx) : _buildExerciseUI(exercise, workoutEx),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildExerciseUI(Exercise exercise, WorkoutExercise workoutEx) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Image.network(
            exercise.image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 250,
              color: AppColors.cardBackground,
              child: const Icon(Icons.fitness_center, size: 50),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          exercise.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMetricCard('SET', '$_currentSet/${workoutEx.sets}'),
            const SizedBox(width: 20),
            _buildMetricCard('REPS', '${workoutEx.reps}'),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Target Time',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        Text(
          '${exercise.duration}s',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.accent),
        ),
      ],
    );
  }

  Widget _buildRestUI(WorkoutExercise workoutEx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const Icon(Icons.timer, size: 80, color: AppColors.success),
        const SizedBox(height: 24),
        const Text(
          'REST',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.success),
        ),
        const SizedBox(height: 16),
        Text(
          'Get ready for Set $_currentSet',
          style: const TextStyle(fontSize: 18, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 48),
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 15.0,
          percent: (_timerSeconds / workoutEx.restTime).clamp(0.0, 1.0),
          center: Text(
            '$_timerSeconds',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          progressColor: AppColors.success,
          backgroundColor: AppColors.cardBackground,
          circularStrokeCap: CircularStrokeCap.round,
          reverse: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding),
      decoration: const BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 32),
            onPressed: _currentExerciseIndex > 0 ? _prevStep : null,
          ),
          GestureDetector(
            onTap: () {
              setState(() => _isPaused = !_isPaused);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 32),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 32),
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text('Exit Workout?'),
        content: const Text('Your progress for this session will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('EXIT', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
