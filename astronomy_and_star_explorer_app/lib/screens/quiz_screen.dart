import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';

class QuizStartScreen extends StatelessWidget {
  const QuizStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ASTRONOMY QUIZ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 100, color: AppColors.accent),
            const SizedBox(height: 24),
            Text('Test Your Knowledge!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('Choose your difficulty level:', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            _buildDifficultyButton(context, 'Easy', AppColors.success),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Medium', AppColors.accent),
            const SizedBox(height: 16),
            _buildDifficultyButton(context, 'Hard', AppColors.error),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String level, Color color) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.mainBackground,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPlayScreen(difficulty: level))),
        child: Text(level.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class QuizPlayScreen extends StatefulWidget {
  final String difficulty;
  const QuizPlayScreen({super.key, required this.difficulty});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  int? _selectedOption;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final questions = await Provider.of<AstronomyProvider>(context, listen: false).getQuizQuestions(widget.difficulty);
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions found.')));

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: const TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 40),
            ...List.generate(question.options.length, (index) {
              final isCorrect = index == question.correctIndex;
              final isSelected = index == _selectedOption;
              
              Color btnColor = AppColors.secondaryBackground;
              if (_answered) {
                if (isCorrect) btnColor = AppColors.success.withOpacity(0.5);
                else if (isSelected) btnColor = AppColors.error.withOpacity(0.5);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: _answered ? null : () => _submitAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _answered && isCorrect ? AppColors.success : Colors.white10,
                        width: 2,
                      ),
                    ),
                    child: Text(question.options[index], style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_currentIndex == _questions.length - 1 ? 'VIEW RESULTS' : 'NEXT QUESTION'),
              ),
          ],
        ),
      ),
    );
  }

  void _submitAnswer(int index) {
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final result = QuizResult(
      date: DateTime.now(),
      score: _score,
      totalQuestions: _questions.length,
      difficulty: widget.difficulty,
    );
    Provider.of<AstronomyProvider>(context, listen: false).addQuizResult(result);
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizResultScreen(result: result)));
  }
}

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;
  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final percentage = (result.score / result.totalQuestions * 100).toInt();
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, size: 120, color: AppColors.accent),
            const SizedBox(height: 24),
            Text('QUIZ COMPLETED!', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text('Difficulty: ${result.difficulty}', style: const TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 4),
              ),
              child: Column(
                children: [
                  Text('$percentage%', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 48)),
                  const Text('SCORE'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('You got ${result.score} out of ${result.totalQuestions} correct!', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('BACK TO HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
