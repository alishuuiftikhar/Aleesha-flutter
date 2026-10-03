import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class SequenceGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const SequenceGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<SequenceGame> createState() => _SequenceGameState();
}

class _SequenceGameState extends State<SequenceGame> {
  final List<int> _sequence = [];
  final List<int> _userSequence = [];
  bool _isPlayingSequence = false;
  int _activeTile = -1;
  int _level = 0;

  final List<Color> _tileColors = [
    Colors.red[400]!,
    Colors.blue[400]!,
    Colors.green[400]!,
    Colors.yellow[700]!,
  ];

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      _level++;
      _userSequence.clear();
      _sequence.add(Random().nextInt(4));
    });
    _playSequence();
  }

  Future<void> _playSequence() async {
    setState(() => _isPlayingSequence = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    for (int tile in _sequence) {
      if (!mounted) return;
      setState(() => _activeTile = tile);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _activeTile = -1);
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    if (mounted) {
      setState(() => _isPlayingSequence = false);
    }
  }

  void _onTileTap(int index) {
    if (_isPlayingSequence) return;

    setState(() => _activeTile = index);
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _activeTile = -1);
    });

    _userSequence.add(index);
    
    if (_userSequence.last != _sequence[_userSequence.length - 1]) {
      widget.onScoreUpdate(-50);
      widget.onGameOver();
      return;
    }

    if (_userSequence.length == _sequence.length) {
      widget.onScoreUpdate(100);
      Future.delayed(const Duration(milliseconds: 800), _nextRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Round $_level',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _isPlayingSequence ? 'Watch the sequence...' : 'Your turn!',
            style: TextStyle(
              fontSize: 16,
              color: _isPlayingSequence ? AppColors.accent : AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _activeTile == index
                          ? _tileColors[index]
                          : _tileColors[index].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _activeTile == index ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: _activeTile == index
                          ? [BoxShadow(color: _tileColors[index], blurRadius: 15)]
                          : [],
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
