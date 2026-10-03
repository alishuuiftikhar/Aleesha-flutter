import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Exam History')),
      body: FutureBuilder<List<ExamAttempt>>(
        future: Provider.of<AppProvider>(context, listen: false).getMyHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No history found.'));

          final attempts = snapshot.data!.reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attempts.length,
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              final date = DateTime.parse(attempt.startTime);
              return Card(
                child: ListTile(
                  title: Text('Exam ID: ${attempt.examId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(date)),
                  trailing: Text(
                    'Score: ${attempt.score}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3949AB)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
