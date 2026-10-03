import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AdminResultsScreen extends StatelessWidget {
  const AdminResultsScreen({super.key});

  Future<List<Map<String, dynamic>>> _getAllResults() async {
    final db = await DatabaseService().database;
    return await db.rawQuery('''
      SELECT exam_attempts.*, users.name as user_name, exams.title as exam_title
      FROM exam_attempts
      JOIN users ON exam_attempts.user_id = users.id
      JOIN exams ON exam_attempts.exam_id = exams.id
      WHERE exam_attempts.status = 1
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Exam Results')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getAllResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final results = snapshot.data!;
          if (results.isEmpty) return const Center(child: Text('No results yet.'));

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final res = results[index];
              return ListTile(
                title: Text(res['user_name']),
                subtitle: Text(res['exam_title']),
                trailing: Text('Score: ${res['score']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          );
        },
      ),
    );
  }
}
