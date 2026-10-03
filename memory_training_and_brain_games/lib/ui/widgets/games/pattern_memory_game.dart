import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class PatternMemoryGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const PatternMemoryGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<PatternMemoryGame> createState() => _PatternMemoryGameState();
}

class _PatternMemoryGameState extends State<PatternMemoryGame> {
  late int _gridSize;
  late int _patternLength;
  List<int> _pattern = [];
  List<int> _userPattern = [];
  bool _showingPattern = false;
  bool _canInput = false;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _setupLevel();
  }

  void _setupLevel() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        _gridSize = 3;
        _patternLength = 3 + (_level ~/ 2);
        break;
      case Difficulty.medium:
        _gridSize = 4;
        _patternLength = 4 + (_level ~/ 2);
        break;
      case Difficulty.hard:
        _gridSize = 5;
        _patternLength = 5 + (_level ~/ 2);
        break;
    }
    _generatePattern();
  }

  void _generatePattern() {
    setState(() {
      _pattern = [];
      _userPattern = [];
      _showingPattern = true;
      _canInput = false;
    });

    final Random random = Random();
    while (_pattern.length < _patternLength) {
      int next = random.nextInt(_gridSize * _gridSize);
      if (!_pattern.contains(next)) {
        _pattern.add(next);
      }
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showingPattern = false;
          _canInput = true;
        });
      }
    });
  }

  void _onTileTap(int index) {
    if (!_canInput || _userPattern.contains(index)) return;

    setState(() {
      _userPattern.add(index);
    });

    if (_pattern.contains(index)) {
      widget.onScoreUpdate(50);
      if (_userPattern.length == _pattern.length) {
        // Level complete
        setState(() {
          _canInput = false;
          _level++;
        });
        Future.delayed(const Duration(milliseconds: 500), _setupLevel);
      }
    } else {
      // Wrong tile
      widget.onScoreUpdate(-100);
      setState(() {
        _canInput = false;
      });
      Future.delayed(const Duration(seconds: 1), widget.onGameOver);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Level: $_level',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            _showingPattern ? 'Memorize the pattern!' : 'Reproduce the pattern!',
            style: TextStyle(
              fontSize: 14,
              color: _showingPattern ? AppColors.accent : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridSize,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: _gridSize * _gridSize,
              itemBuilder: (context, index) {
                bool isHighlighted = (_showingPattern && _pattern.contains(index)) ||
                    (_userPattern.contains(index) && _pattern.contains(index));
                bool isError = _userPattern.contains(index) && !_pattern.contains(index);

                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppColors.primary
                          : isError
                              ? AppColors.error
                              : AppColors.secondaryBackground,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
