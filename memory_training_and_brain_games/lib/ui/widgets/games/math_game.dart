import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class MathGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const MathGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  late int _num1;
  late int _num2;
  late String _operator;
  late int _correctAnswer;
  List<int> _options = [];
  int _level = 1;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    int maxRange = 10;
    List<String> operators = ['+'];

    switch (widget.difficulty) {
      case Difficulty.easy:
        maxRange = 10 + (_level * 2);
        operators = ['+', '-'];
        break;
      case Difficulty.medium:
        maxRange = 20 + (_level * 5);
        operators = ['+', '-', '*'];
        break;
      case Difficulty.hard:
        maxRange = 50 + (_level * 10);
        operators = ['+', '-', '*', '/'];
        break;
    }

    _operator = operators[_random.nextInt(operators.length)];
    
    if (_operator == '/') {
      _num2 = _random.nextInt(9) + 2;
      _correctAnswer = _random.nextInt(10) + 1;
      _num1 = _num2 * _correctAnswer;
    } else if (_operator == '*') {
      _num1 = _random.nextInt(12) + 2;
      _num2 = _random.nextInt(12) + 2;
      _correctAnswer = _num1 * _num2;
    } else {
      _num1 = _random.nextInt(maxRange) + 1;
      _num2 = _random.nextInt(maxRange) + 1;
      _correctAnswer = _operator == '+' ? _num1 + _num2 : _num1 - _num2;
    }

    _options = [_correctAnswer];
    while (_options.length < 4) {
      int offset = _random.nextInt(10) + 1;
      int wrong = _random.nextBool() ? _correctAnswer + offset : _correctAnswer - offset;
      if (!_options.contains(wrong)) {
        _options.add(wrong);
      }
    }
    _options.shuffle();
    setState(() {});
  }

  void _onAnswer(int selected) {
    if (selected == _correctAnswer) {
      widget.onScoreUpdate(100);
      setState(() => _level++);
      _generateProblem();
    } else {
      widget.onScoreUpdate(-50);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Level $_level', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(
            '$_num1 $_operator $_num2 = ?',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _options.map((opt) => ElevatedButton(
              onPressed: () => _onAnswer(opt),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.text,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('$opt', style: const TextStyle(fontSize: 20)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
