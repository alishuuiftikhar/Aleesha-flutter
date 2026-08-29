import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/data_service.dart';
import 'lesson_detail_screen.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = DataService().lessons;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Driving Lessons'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Card(
            color: AppColors.cardBackground,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(lesson.category),
              trailing: lesson.isCompleted 
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson))
              ),
            ),
          );
        },
      ),
    );
  }
}
