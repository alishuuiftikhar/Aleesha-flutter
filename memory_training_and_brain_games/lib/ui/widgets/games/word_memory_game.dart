import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class WordMemoryGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const WordMemoryGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<WordMemoryGame> createState() => _WordMemoryGameState();
}

class _WordMemoryGameState extends State<WordMemoryGame> {
  final List<String> _allWords = [
    'Apple', 'River', 'Mountain', 'Cloud', 'Elephant', 'Guitar', 'Ocean', 'Forest',
    'Window', 'Camera', 'Rocket', 'Jungle', 'Diamond', 'Planet', 'Breeze', 'Castle',
    'Hammer', 'Pillow', 'Bridge', 'Desert', 'Garden', 'Mirror', 'Bottle', 'Island',
  ];
  
  List<String> _seenWords = [];
  String _currentWord = '';
  int _score = 0;
  int _level = 0;

  @override
  void initState() {
    super.initState();
    _nextWord();
  }

  void _nextWord() {
    final Random random = Random();
    setState(() {
      _level++;
      // 50% chance to show a seen word if we have seen words
      if (_seenWords.isNotEmpty && random.nextBool()) {
        _currentWord = _seenWords[random.nextInt(_seenWords.length)];
      } else {
        // Find a word not yet seen
        List<String> availableWords = _allWords.where((w) => !_seenWords.contains(w)).toList();
        if (availableWords.isEmpty) {
          // All words seen, game over or reset? Let's just win
          widget.onGameOver();
          return;
        }
        _currentWord = availableWords[random.nextInt(availableWords.length)];
      }
    });
  }

  void _onAnswer(bool seen) {
    bool alreadySeen = _seenWords.contains(_currentWord);
    
    if (seen == alreadySeen) {
      widget.onScoreUpdate(50);
      if (!alreadySeen) {
        _seenWords.add(_currentWord);
      }
      _nextWord();
    } else {
      widget.onScoreUpdate(-100);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Word $_level',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Have you seen this word before?',
          style: TextStyle(fontSize: 18, color: AppColors.secondary),
        ),
        const SizedBox(height: 60),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Text(
            _currentWord,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton('NEW', false, AppColors.accent),
            _buildButton('SEEN', true, AppColors.success),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(String label, bool value, Color color) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _onAnswer(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
