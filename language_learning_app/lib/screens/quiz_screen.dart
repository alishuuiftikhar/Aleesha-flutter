import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/app_provider.dart';
import '../constants/colors.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final questions = provider.questions.where((q) => q.lessonId == widget.lessonId).toList();

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("No questions for this lesson yet.")),
      );
    }

    final question = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - ${(_currentQuestionIndex + 1)} / ${questions.length}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: progress,
              backgroundColor: AppColors.secondaryBackground,
              progressColor: AppColors.secondary,
              barRadius: const Radius.circular(10),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 40),
            Text(
              "Question ${_currentQuestionIndex + 1} of ${questions.length}",
              style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ...question.options.map((option) => _buildOption(option, question.correctAnswer)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAnswered ? () => _nextQuestion(questions) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(_currentQuestionIndex == questions.length - 1 ? "Finish" : "Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option, String correctAnswer) {
    bool isCorrect = option == correctAnswer;
    bool isSelected = _selectedOption == option;
    
    Color borderColor = Colors.transparent;
    Color bgColor = AppColors.cardBackground;
    
    if (_isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.1);
      } else if (isSelected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.1);
      }
    } else if (isSelected) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.05);
    }

    return GestureDetector(
      onTap: _isAnswered ? null : () {
        setState(() {
          _selectedOption = option;
          _isAnswered = true;
          if (isCorrect) _score += 10;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (_isAnswered && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.success)
            else if (_isAnswered && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.error),
          ],
        ),
      ),
    );
  }

  void _nextQuestion(List questions) {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _isAnswered = false;
      });
    } else {
      Provider.of<AppProvider>(context, listen: false).completeLesson(widget.lessonId);
      Provider.of<AppProvider>(context, listen: false).addPoints(_score);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _score,
            totalQuestions: questions.length,
            lessonId: widget.lessonId,
          ),
        ),
      );
    }
  }
}
