import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/game_model.dart';
import '../../services/storage_service.dart';

class WordPuzzlePage extends StatefulWidget {
  final String difficulty;
  const WordPuzzlePage({super.key, required this.difficulty});

  @override
  State<WordPuzzlePage> createState() => _WordPuzzlePageState();
}

class _WordPuzzlePageState extends State<WordPuzzlePage> {
  final List<String> _words = ['FLUTTER', 'DART', 'PUZZLE', 'MOBILE', 'WIDGET', 'SCREEN', 'LOGIC', 'DEVELOPER', 'INTERFACE', 'COLLECTION'];
  late String _currentWord;
  late String _scrambledWord;
  final TextEditingController _controller = TextEditingController();
  int _score = 0;
  late int _seconds;
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _seconds = widget.difficulty == 'Easy' ? 90 : (widget.difficulty == 'Medium' ? 60 : 30);
    _startNewGame();
  }

  void _startNewGame() {
    _score = 0;
    _seconds = widget.difficulty == 'Easy' ? 90 : (widget.difficulty == 'Medium' ? 60 : 30);
    _isGameOver = false;
    _nextWord();
    _startTimer();
  }

  void _nextWord() {
    _currentWord = (_words..shuffle()).first;
    List<String> chars = _currentWord.split('')..shuffle();
    _scrambledWord = chars.join('');
    if (_scrambledWord == _currentWord) _nextWord();
    _controller.clear();
    setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _isGameOver = true);
    _saveScore();
    _showGameOverDialog();
  }

  void _checkAnswer() {
    if (_controller.text.toUpperCase() == _currentWord) {
      setState(() {
        _score += 10;
        _nextWord();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again!'), duration: Duration(milliseconds: 500)),
      );
    }
  }

  void _saveScore() async {
    final score = GameScore(
      gameId: 'word',
      score: _score,
      duration: '1:00',
      date: DateTime.now(),
    );
    await StorageService().saveScore(score);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Your final score is $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Scramble'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard('Score', '$_score'),
                _infoCard('Time', '$_seconds'),
              ],
            ),
            const Spacer(),
            Text(
              'Unscramble the word:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              _scrambledWord,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Type here...',
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('SUBMIT'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.primary)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}
