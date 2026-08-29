import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../services/workout_provider.dart';
import '../utils/constants.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final List<WorkoutExercise> _selectedExercises = [];
  String _selectedLevel = 'Beginner';
  String _selectedCategory = 'Full Body';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Custom Workout'),
        actions: [
          TextButton(
            onPressed: _saveWorkout,
            child: const Text('SAVE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                hintText: 'e.g., Morning Shred',
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your workout goals...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            const Text('Intensity Level', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(level, style: const TextStyle(fontSize: 12)),
                    value: level,
                    groupValue: _selectedLevel,
                    onChanged: (val) => setState(() => _selectedLevel = val!),
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showAddExerciseDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Exercise'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedExercises.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No exercises added yet', style: TextStyle(color: AppColors.secondaryText)),
                ),
              ),
            ..._selectedExercises.asMap().entries.map((entry) {
              final index = entry.key;
              final we = entry.value;
              final provider = Provider.of<WorkoutProvider>(context, listen: false);
              
              Exercise? exercise;
              try {
                exercise = provider.exercises.firstWhere((e) => e.id == we.exerciseId);
              } catch (e) {
                return const SizedBox.shrink();
              }
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      exercise.image, 
                      width: 40, 
                      height: 40, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fitness_center),
                    ),
                  ),
                  title: Text(exercise.name),
                  subtitle: Text('${we.sets} sets | ${we.reps} reps'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.primary),
                    onPressed: () => setState(() => _selectedExercises.removeAt(index)),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAddExerciseDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondaryBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return _AddExerciseBottomSheet(
          onAdd: (workoutEx) {
            setState(() => _selectedExercises.add(workoutEx));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedExercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one exercise')),
        );
        return;
      }

      final workout = Workout(
        id: const Uuid().v4(),
        title: _nameController.text,
        description: _descController.text,
        image: 'https://images.unsplash.com/photo-1517838276558-c3d98fb35e16?w=800&q=80',
        level: _selectedLevel,
        category: _selectedCategory,
        exercises: List.from(_selectedExercises),
        isCustom: true,
      );

      await Provider.of<WorkoutProvider>(context, listen: false).saveCustomWorkout(workout);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully!')),
        );
      }
    }
  }
}

class _AddExerciseBottomSheet extends StatefulWidget {
  final Function(WorkoutExercise) onAdd;
  const _AddExerciseBottomSheet({required this.onAdd});

  @override
  State<_AddExerciseBottomSheet> createState() => _AddExerciseBottomSheetState();
}

class _AddExerciseBottomSheetState extends State<_AddExerciseBottomSheet> {
  Exercise? _selectedExercise;
  int _sets = 3;
  int _reps = 10;
  int _rest = 60;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<Exercise>(
            value: _selectedExercise,
            hint: const Text('Choose an exercise'),
            items: provider.exercises.map((e) {
              return DropdownMenuItem(value: e, child: Text(e.name));
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedExercise = val;
                _sets = val?.defaultSets ?? 3;
                _reps = val?.defaultReps ?? 10;
                _rest = val?.restTime ?? 60;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildCounter('Sets', _sets, (v) => setState(() => _sets = v))),
              const SizedBox(width: 16),
              Expanded(child: _buildCounter('Reps', _reps, (v) => setState(() => _reps = v))),
            ],
          ),
          const SizedBox(height: 24),
          _buildCounter('Rest Time (sec)', _rest, (v) => setState(() => _rest = v), step: 5),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedExercise == null ? null : () {
                widget.onAdd(WorkoutExercise(
                  exerciseId: _selectedExercise!.id,
                  sets: _sets,
                  reps: _reps,
                  restTime: _rest,
                ));
              },
              child: const Text('ADD TO WORKOUT'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged, {int step = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            _counterBtn(Icons.remove, () => value > step ? onChanged(value - step) : null),
            Expanded(child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            _counterBtn(Icons.add, () => onChanged(value + step)),
          ],
        ),
      ],
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}
