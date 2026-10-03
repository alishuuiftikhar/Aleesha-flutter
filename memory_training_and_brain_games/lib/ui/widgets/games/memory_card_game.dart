import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class MemoryCardGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const MemoryCardGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<MemoryCardGame> createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  late List<String> _cardIcons;
  late List<bool> _cardFlipped;
  late List<bool> _cardMatched;
  int? _firstSelectedIndex;
  bool _isProcessing = false;
  int _moves = 0;

  final List<String> _allIcons = [
    '🍎', '🍌', '🍇', '🍊', '🍓', '🍍', '🥝', '🍉',
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑',
  ];

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    int pairsCount;
    switch (widget.difficulty) {
      case Difficulty.easy: pairsCount = 6; break;
      case Difficulty.medium: pairsCount = 8; break;
      case Difficulty.hard: pairsCount = 12; break;
    }

    final List<String> selectedIcons = (_allIcons..shuffle()).take(pairsCount).toList();
    _cardIcons = [...selectedIcons, ...selectedIcons]..shuffle();
    _cardFlipped = List.generate(_cardIcons.length, (_) => false);
    _cardMatched = List.generate(_cardIcons.length, (_) => false);
    _firstSelectedIndex = null;
    _moves = 0;
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cardFlipped[index] || _cardMatched[index]) return;

    setState(() {
      _cardFlipped[index] = true;
    });

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      _moves++;
      _isProcessing = true;
      
      if (_cardIcons[_firstSelectedIndex!] == _cardIcons[index]) {
        // Match!
        setState(() {
          _cardMatched[_firstSelectedIndex!] = true;
          _cardMatched[index] = true;
          _isProcessing = false;
          _firstSelectedIndex = null;
        });
        widget.onScoreUpdate(100);
        
        if (_cardMatched.every((matched) => matched)) {
          Future.delayed(const Duration(milliseconds: 500), widget.onGameOver);
        }
      } else {
        // No match
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _cardFlipped[_firstSelectedIndex!] = false;
              _cardFlipped[index] = false;
              _isProcessing = false;
              _firstSelectedIndex = null;
            });
            widget.onScoreUpdate(-10);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = widget.difficulty == Difficulty.easy ? 3 : 4;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'Moves: $_moves',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _cardIcons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onCardTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _cardFlipped[index] || _cardMatched[index]
                        ? AppColors.cardBackground
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _cardFlipped[index] || _cardMatched[index]
                          ? _cardIcons[index]
                          : '?',
                      style: TextStyle(
                        fontSize: widget.difficulty == Difficulty.hard ? 20 : 28,
                        color: _cardFlipped[index] || _cardMatched[index]
                            ? AppColors.text
                            : Colors.white,
                      ),
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
