import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class NumberMemoryGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const NumberMemoryGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<NumberMemoryGame> createState() => _NumberMemoryGameState();
}

class _NumberMemoryGameState extends State<NumberMemoryGame> {
  String _targetNumber = '';
  final TextEditingController _controller = TextEditingController();
  bool _showingNumber = true;
  int _digits = 4;
  int _level = 1;
  int _timerValue = 3;

  @override
  void initState() {
    super.initState();
    _startNextLevel();
  }

  void _startNextLevel() {
    setState(() {
      _showingNumber = true;
      _controller.clear();
      _targetNumber = _generateNumber(_digits);
      _timerValue = 3 + (_digits ~/ 2);
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timerValue > 0) {
            _timerValue--;
          } else {
            _showingNumber = false;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _generateNumber(int length) {
    final Random random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }

  void _submit() {
    if (_controller.text == _targetNumber) {
      widget.onScoreUpdate(_digits * 10);
      setState(() {
        _level++;
        _digits++;
      });
      _startNextLevel();
    } else {
      widget.onScoreUpdate(-50);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Level $_level',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        if (_showingNumber) ...[
          const Text('Memorize this number:'),
          const SizedBox(height: 20),
          Text(
            _targetNumber,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text('Time left: $_timerValue s'),
        ] else ...[
          const Text('What was the number?'),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: true,
            style: const TextStyle(fontSize: 32, letterSpacing: 8),
            decoration: InputDecoration(
              hintText: 'Type here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text('Submit'),
          ),
        ],
      ],
    );
  }
}
