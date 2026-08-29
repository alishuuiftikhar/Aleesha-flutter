import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../theme.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final today = DateTime.now();
    final isCompleted = habit.completedDays.any((d) => 
      d.year == today.year && d.month == today.month && d.day == today.day
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Show details or edit? Let's toggle for now if tapped on the check button
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(habit.colorValue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(habit.category),
                  color: Color(habit.colorValue),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department, size: 16, color: AppColors.accent),
                        Text(
                          ' ${habit.currentStreak} day streak',
                          style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.category, size: 16, color: AppColors.secondary),
                        Text(
                          ' ${habit.category}',
                          style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  habit.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: habit.isFavorite ? Colors.redAccent : AppColors.text.withOpacity(0.3),
                  size: 20,
                ),
                onPressed: () {
                  habitProvider.updateHabit(habit.copyWith(isFavorite: !habit.isFavorite));
                },
              ),
              GestureDetector(
                onLongPress: () {
                  _showDeleteDialog(context, habitProvider);
                },
                onTap: () {
                  habitProvider.toggleHabitCompletion(habit.id, today);
                  if (!isCompleted) {
                    _showCompletionAnimation(context);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCompleted ? AppColors.primary : AppColors.secondaryBackground,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: isCompleted ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health': return Icons.favorite;
      case 'fitness': return Icons.fitness_center;
      case 'mind': return Icons.psychology;
      case 'productivity': return Icons.work;
      default: return Icons.eco;
    }
  }

  void _showCompletionAnimation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Awesome! Habit completed. 🌿'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HabitProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.deleteHabit(habit.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
