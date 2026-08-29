import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../constants/colors.dart';
import '../lesson_details_screen.dart';

class LessonsTab extends StatelessWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final lessons = provider.lessons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final isCompleted = provider.completedLessonIds.contains(lesson.id);
          
          return Card(
            color: AppColors.cardBackground,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: isCompleted ? AppColors.secondary : AppColors.secondaryBackground,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.secondary.withOpacity(0.1) : AppColors.secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? AppColors.secondary : AppColors.primary,
                  ),
                ),
              ),
              title: Text(
                lesson.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                lesson.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: isCompleted
                  ? const Icon(Icons.check_circle, color: AppColors.secondary)
                  : const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LessonDetailsScreen(lesson: lesson)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
