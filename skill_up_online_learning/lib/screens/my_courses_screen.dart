import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Courses', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CourseProgressCard(title: 'Flutter UI Masterclass', progress: 0.65, timeLeft: '2h 30m left'),
          _CourseProgressCard(title: 'Advanced UI/UX Design', progress: 0.30, timeLeft: '10h 15m left'),
          _CourseProgressCard(title: 'Python for Data Science', progress: 0.90, timeLeft: '45m left'),
        ],
      ),
    );
  }
}

class _CourseProgressCard extends StatelessWidget {
  final String title, timeLeft;
  final double progress;
  const _CourseProgressCard({required this.title, required this.progress, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(timeLeft, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF0D9488),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${(progress * 100).toInt()}% Complete', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
