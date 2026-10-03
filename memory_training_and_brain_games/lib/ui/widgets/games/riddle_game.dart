import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class RiddleGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const RiddleGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<RiddleGame> createState() => _RiddleGameState();
}

class _RiddleGameState extends State<RiddleGame> {
  final List<Map<String, dynamic>> _riddles = [
    {
      'q': 'I speak without a mouth and hear without ears. I have no body, but I come alive with wind.',
      'a': 'Echo',
      'o': ['Wind', 'Echo', 'Ghost', 'Shadow']
    },
    {
      'q': 'The more of this there is, the less you see. What is it?',
      'a': 'Darkness',
      'o': ['Light', 'Fog', 'Darkness', 'Smoke']
    },
    {
      'q': 'What has keys but can\'t open locks?',
      'a': 'Piano',
      'o': ['Keyboard', 'Map', 'Piano', 'Skeleton']
    },
    {
      'q': 'I’m tall when I’m young, and I’m short when I’m old. What am I?',
      'a': 'Candle',
      'o': ['Tree', 'Candle', 'Person', 'Pencil']
    },
  ];

  late int _currentIndex;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentIndex = _random.nextInt(_riddles.length);
  }

  void _onAnswer(String selected) {
    if (selected == _riddles[_currentIndex]['a']) {
      widget.onScoreUpdate(300);
      setState(() {
        _currentIndex = _random.nextInt(_riddles.length);
      });
    } else {
      widget.onScoreUpdate(-100);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    var riddle = _riddles[_currentIndex];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              riddle['q'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 30),
          ... (riddle['o'] as List<String>).map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _onAnswer(opt),
                child: Text(opt, style: const TextStyle(fontSize: 16)),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
