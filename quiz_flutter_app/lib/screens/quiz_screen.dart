import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../constants.dart';
import '../models/category.dart';
import '../models/question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Category category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  late Timer _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timeLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          _handleNextQuestion(); // Auto-skip or mark wrong if time runs out
        }
      });
    });
  }

  void _handleAnswerSelection(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      _timer.cancel();

      if (index == widget.category.questions[_currentQuestionIndex].correctIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      _handleNextQuestion();
    });
  }

  void _handleNextQuestion() {
    if (_currentQuestionIndex < widget.category.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
        _startTimer();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            categoryName: widget.category.name,
            score: _score,
            totalQuestions: widget.category.questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuestion = widget.category.questions[_currentQuestionIndex];
    final double progress = (_currentQuestionIndex + 1) / widget.category.questions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: LinearPercentIndicator(
          lineHeight: 8.0,
          percent: progress,
          backgroundColor: AppColors.cardBackground,
          progressColor: AppColors.accent,
          barRadius: const Radius.circular(10),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '$_timeLeft',
                style: GoogleFonts.orbitron(
                  color: _timeLeft < 5 ? AppColors.wrong : AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.category.questions.length}',
              style: GoogleFonts.rajdhani(
                color: AppColors.accent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.text,
              style: GoogleFonts.rajdhani(
                color: AppColors.textMain,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  return _OptionTile(
                    option: currentQuestion.options[index],
                    index: index,
                    isSelected: _selectedAnswerIndex == index,
                    isCorrect: currentQuestion.correctIndex == index,
                    isAnswered: _isAnswered,
                    onTap: () => _handleAnswerSelection(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.primary.withOpacity(0.3);
    Color bgColor = AppColors.cardBackground;
    
    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.correct;
        bgColor = AppColors.correct.withOpacity(0.1);
      } else if (isSelected && !isCorrect) {
        borderColor = AppColors.wrong;
        bgColor = AppColors.wrong.withOpacity(0.1);
      }
    } else if (isSelected) {
      borderColor = AppColors.accent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isAnswered && isCorrect ? AppColors.correct : AppColors.textSecondary,
                  ),
                ),
                child: Center(
                  child: isAnswered && isCorrect
                      ? const Icon(Icons.check, size: 20, color: AppColors.correct)
                      : Text(
                          String.fromCharCode(65 + index),
                          style: GoogleFonts.rajdhani(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.rajdhani(
                    color: AppColors.textMain,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
