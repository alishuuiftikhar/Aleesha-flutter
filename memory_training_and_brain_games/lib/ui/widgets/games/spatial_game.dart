import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../utils/app_colors.dart';

class SpatialGame extends StatefulWidget {
  final Difficulty difficulty;
  final Function(int) onScoreUpdate;
  final VoidCallback onGameOver;

  const SpatialGame({
    super.key,
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onGameOver,
  });

  @override
  State<SpatialGame> createState() => _SpatialGameState();
}

class _SpatialGameState extends State<SpatialGame> {
  late int _rotationCount;
  late double _currentRotation;
  final Random _random = Random();
  bool _isRotating = false;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    setState(() {
      _rotationCount = 1 + (_level ~/ 2);
      _currentRotation = 0;
      _isRotating = true;
    });
    _animateRotation();
  }

  Future<void> _animateRotation() async {
    for (int i = 0; i < _rotationCount; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _currentRotation += (pi / 2) * (_random.nextBool() ? 1 : -1);
      });
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _isRotating = false);
  }

  void _onAnswer(double angle) {
    double normalizedCurrent = (_currentRotation % (2 * pi)).abs();
    double normalizedSelected = (angle % (2 * pi)).abs();
    
    if ((normalizedCurrent - normalizedSelected).abs() < 0.1) {
      widget.onScoreUpdate(200);
      setState(() => _level++);
      _startRound();
    } else {
      widget.onScoreUpdate(-100);
      widget.onGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Where is the arrow pointing now?',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          AnimatedRotation(
            turns: _currentRotation / (2 * pi),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: const Icon(Icons.arrow_upward, size: 80, color: AppColors.primary),
          ),
          const SizedBox(height: 40),
          if (!_isRotating)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildDirectionBtn('UP', 0),
                _buildDirectionBtn('RIGHT', pi / 2),
                _buildDirectionBtn('DOWN', pi),
                _buildDirectionBtn('LEFT', -pi / 2),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDirectionBtn(String label, double angle) {
    return ElevatedButton(
      onPressed: () => _onAnswer(angle),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}
