import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';

class ResultScreen extends StatelessWidget {
  final int attemptId;
  const ResultScreen({super.key, required this.attemptId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamAttempt>>(
      future: Provider.of<AppProvider>(context, listen: false).getMyHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final attempt = snapshot.data!.firstWhere((a) => a.id == attemptId);

        return Scaffold(
          appBar: AppBar(title: const Text('Exam Result'), automaticallyImplyLeading: false),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 100, color: Color(0xFFF9A825)),
                  const SizedBox(height: 24),
                  const Text('Congratulations!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('You have completed the exam.'),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('Your Score', style: TextStyle(fontSize: 18)),
                        Text(
                          '${attempt.score}',
                          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFF3949AB)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
