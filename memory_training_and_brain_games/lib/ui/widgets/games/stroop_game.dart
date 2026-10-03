import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class StroopGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const StroopGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<StroopGame> createState() => _StroopGameState();
}

class _StroopGameState extends State<StroopGame> {
  final List<Map<String, dynamic>> _colorData = [
    {'name': 'RED', 'color': Colors.red},
    {'name': 'BLUE', 'color': Colors.blue},
    {'name': 'GREEN', 'color': Colors.green},
    {'name': 'YELLOW', 'color': Colors.yellow[700]},
    {'name': 'ORANGE', 'color': Colors.orange},
    {'name': 'PURPLE', 'color': Colors.purple},
  ];

  late int _textIndex;
  late int _colorIndex;
  int _level = 1;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _textIndex = _random.nextInt(_colorData.length);
      // High chance of mismatch
      _colorIndex = _random.nextInt(_colorData.length);
    });
  }

  void _onAnswer(int selectedColorIndex) {
    if (selectedColorIndex == _colorIndex) {
      widget.onScoreUpdate(100);
      setState(() => _level++);
      _nextRound();
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
          const Text(
            'Select the COLOR of the text',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.secondary),
          ),
          const SizedBox(height: 30),
          Text(
            _colorData[_textIndex]['name'],
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: _colorData[_colorIndex]['color'],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(_colorData.length, (index) => GestureDetector(
              onTap: () => _onAnswer(index),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _colorData[index]['color'],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
