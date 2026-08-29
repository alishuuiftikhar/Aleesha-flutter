import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../theme/app_colors.dart';
import '../services/data_service.dart';

class QuizResultScreen extends StatefulWidget {
  final Quiz quiz;
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.score,
    required this.total,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    DataService().saveQuizAttempt(widget.quiz.id, widget.score, widget.total);
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = widget.score / widget.total;
    final bool isPassed = percentage >= 0.7;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPassed ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
                size: 100,
                color: isPassed ? AppColors.accent : AppColors.error,
              ),
              const SizedBox(height: 24),
              Text(
                isPassed ? 'Congratulations!' : 'Keep Practicing!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
              const SizedBox(height: 12),
              Text(
                'You scored ${widget.score} out of ${widget.total}',
                style: const TextStyle(fontSize: 20, color: AppColors.text),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 8),
                ),
                child: Center(
                  child: Text(
                    '${(percentage * 100).toInt()}%',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Go Home'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // In a real app, you might want to restart the quiz directly
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
