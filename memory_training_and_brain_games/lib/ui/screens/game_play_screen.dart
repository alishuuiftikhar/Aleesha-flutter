import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game.dart';
import '../../providers/game_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/games/memory_card_game.dart';
import '../widgets/games/pattern_memory_game.dart';
import '../widgets/games/number_memory_game.dart';
import '../widgets/games/sequence_game.dart';
import '../widgets/games/word_memory_game.dart';
import '../widgets/games/math_game.dart';
import '../widgets/games/stroop_game.dart';
import '../widgets/games/eagle_eye_game.dart';
import '../widgets/games/spatial_game.dart';
import '../widgets/games/riddle_game.dart';
import 'results_screen.dart';

class GamePlayScreen extends StatefulWidget {
  final GameModel game;

  const GamePlayScreen({super.key, required this.game});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  int _secondsLeft = 60;
  Timer? _timer;
  bool _isPaused = false;
  int _score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_secondsLeft > 0) {
            _secondsLeft--;
          } else {
            _timer?.cancel();
            _onGameOver();
          }
        });
      }
    });
  }

  void _onGameOver() {
    if (_isGameOver) return;
    setState(() => _isGameOver = true);
    
    // Save result
    Provider.of<GameProvider>(context, listen: false).saveGameResult(
      widget.game.id,
      _score,
      widget.game.difficulty,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          game: widget.game,
          score: _score,
        ),
      ),
    );
  }

  void _updateScore(int delta) {
    setState(() {
      _score += delta;
      if (_score < 0) _score = 0;
    });
  }

  void _pauseGame() {
    setState(() => _isPaused = true);
    _showPauseDialog();
  }

  void _resumeGame() {
    setState(() => _isPaused = false);
  }

  void _restartGame() {
    setState(() {
      _secondsLeft = 60;
      _score = 0;
      _isPaused = false;
      _isGameOver = false;
    });
    _timer?.cancel();
    _startTimer();
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Paused'),
        content: const Text('Do you want to continue or restart?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text('Restart'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeGame();
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _pauseGame,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _buildGameWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.secondaryBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.timer, '$_secondsLeft s', AppColors.primary),
          _buildInfoItem(Icons.stars, '$_score', AppColors.accent),
          _buildInfoItem(Icons.trending_up, widget.game.difficulty.toString().split('.').last, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGameWidget() {
    switch (widget.game.type) {
      case GameType.memoryCard:
        return MemoryCardGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.patternMemory:
        return PatternMemoryGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.numberMemory:
        return NumberMemoryGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.sequence:
        return SequenceGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.wordMemory:
        return WordMemoryGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.mathLogic:
        return MathGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.colorMatch:
        return StroopGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.speedSearch:
        return EagleEyeGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.spatialNavigation:
        return SpatialGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      case GameType.logicPuzzle:
        return RiddleGame(
          difficulty: widget.game.difficulty,
          onScoreUpdate: _updateScore,
          onGameOver: _onGameOver,
        );
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: AppColors.secondary),
              const SizedBox(height: 20),
              Text(
                '${widget.game.title} is coming in the next update!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: AppColors.secondary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        );
    }
  }
}
