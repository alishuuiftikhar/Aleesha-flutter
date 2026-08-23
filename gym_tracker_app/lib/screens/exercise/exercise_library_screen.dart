import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../services/database_service.dart';
import '../../models/exercise.dart';
import 'exercise_details_screen.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final DatabaseService _dbService = DatabaseService();
  final List<String> _categories = ['All', 'Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Cardio'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _refreshExercises();
  }

  void _refreshExercises() {
    setState(() {
      _exercisesFuture = _dbService.getExercises();
    });
  }

  Future<void> _showAddExerciseDialog() async {
    final nameController = TextEditingController();
    String category = 'Chest';
    
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('ADD EXERCISE', style: GoogleFonts.bebasNeue(letterSpacing: 1.2)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Exercise Name',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: AppColors.cardBackground,
                items: _categories.where((c) => c != 'All').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setDialogState(() => category = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText))),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    await _dbService.addExercise(nameController.text.trim(), category);
                    if (mounted) {
                      Navigator.pop(context);
                      _refreshExercises();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
                      );
                    }
                  }
                }
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EXERCISE LIBRARY', style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
            onPressed: _showAddExerciseDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _selectedCategory = category),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.cardBackground,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Exercise>>(
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }
                
                final exercises = snapshot.data ?? [];
                final filteredExercises = exercises.where((e) {
                  final matchesCategory = _selectedCategory == 'All' || e.category == _selectedCategory;
                  final matchesSearch = e.name.toLowerCase().contains(_searchQuery);
                  return matchesCategory && matchesSearch;
                }).toList();

                if (exercises.isEmpty) {
                  return _buildEmptyState();
                }

                if (filteredExercises.isEmpty) {
                  return const Center(child: Text('No matching exercises found', style: TextStyle(color: AppColors.secondaryText)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    return _buildExerciseCard(exercise);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.mainBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 30),
        ),
        title: Text(exercise.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(exercise.category, style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.secondaryText),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseDetailsScreen(exercise: exercise))),
      ),
    );
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
          Text(
            'The "exercises" table was not found. Please run the SQL script in Supabase SQL Editor.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 14),
          ),
          const SizedBox(height: 25),
          ElevatedButton(onPressed: _refreshExercises, child: const Text('RETRY')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 80, color: AppColors.divider),
          const SizedBox(height: 20),
          Text('LIBRARY IS EMPTY', style: GoogleFonts.bebasNeue(fontSize: 24, color: AppColors.secondaryText)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _showAddExerciseDialog,
            child: const Text('ADD FIRST EXERCISE'),
          ),
        ],
      ),
    );
  }
}
