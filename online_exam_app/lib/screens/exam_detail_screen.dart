import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'exam_taking_screen.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;
  const ExamDetailScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exam.title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE4FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.description, size: 48, color: Color(0xFF3949AB)),
                  const SizedBox(height: 16),
                  Text(exam.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(exam.category, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.timer, 'Duration', '${exam.durationMinutes} Minutes'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.grade, 'Total Marks', '${exam.totalMarks}'),
            const SizedBox(height: 24),
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(exam.description),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9A825),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ExamTakingScreen(exam: exam)),
                );
              },
              child: const Text('START EXAM', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3949AB)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
