import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class EagleEyeGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const EagleEyeGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<EagleEyeGame> createState() => _EagleEyeGameState();
}

class _EagleEyeGameState extends State<EagleEyeGame> {
  late String _targetEmoji;
  late String _distractorEmoji;
  late int _gridSize;
  late int _targetIndex;
  int _level = 1;
  final Random _random = Random();

  final List<List<String>> _pairs = [
    ['🍎', '🍑'], ['🐱', '🐯'], ['🏐', '⚽'], ['🥦', '🥬'],
    ['⌚', '⌛'], ['M', 'W'], ['8', 'B'], ['O', '0'],
  ];

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    setState(() {
      var pair = _pairs[_random.nextInt(_pairs.length)];
      _targetEmoji = pair[0];
      _distractorEmoji = pair[1];
      
      _gridSize = widget.difficulty == Difficulty.easy ? 4 : (widget.difficulty == Difficulty.medium ? 6 : 8);
      _targetIndex = _random.nextInt(_gridSize * _gridSize);
    });
  }

  void _onTileTap(int index) {
    if (index == _targetIndex) {
      widget.onScoreUpdate(150);
      setState(() => _level++);
      _setupLevel();
    } else {
      widget.onScoreUpdate(-100);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Find the $_targetEmoji', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridSize,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: _gridSize * _gridSize,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onTileTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      index == _targetIndex ? _targetEmoji : _distractorEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
