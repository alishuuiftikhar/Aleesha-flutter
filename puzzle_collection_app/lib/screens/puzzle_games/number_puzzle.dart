import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/game_model.dart';
import '../../services/storage_service.dart';

class NumberPuzzlePage extends StatefulWidget {
  final String difficulty;
  const NumberPuzzlePage({super.key, required this.difficulty});

  @override
  State<NumberPuzzlePage> createState() => _NumberPuzzlePageState();
}

class _NumberPuzzlePageState extends State<NumberPuzzlePage> {
  late List<int> _numbers;
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isPaused = false;
  bool _isGameOver = false;
  late int _size;

  @override
  void initState() {
    super.initState();
    _size = widget.difficulty == 'Easy' ? 3 : (widget.difficulty == 'Medium' ? 4 : 5);
    _startNewGame();
  }

  void _startNewGame() {
    _numbers = List.generate(_size * _size, (index) => index);
    _numbers.shuffle();
    _moves = 0;
    _seconds = 0;
    _isGameOver = false;
    _isPaused = false;
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isGameOver) {
        setState(() => _seconds++);
      }
    });
  }

  void _handleTap(int index) {
    if (_isPaused || _isGameOver) return;

    int emptyIndex = _numbers.indexOf(0);
    if (_isAdjacent(index, emptyIndex)) {
      setState(() {
        _numbers[emptyIndex] = _numbers[index];
        _numbers[index] = 0;
        _moves++;
        _checkWin();
      });
    }
  }

  bool _isAdjacent(int idx1, int idx2) {
    int row1 = idx1 ~/ _size;
    int col1 = idx1 % _size;
    int row2 = idx2 ~/ _size;
    int col2 = idx2 % _size;
    return (row1 == row2 && (col1 - col2).abs() == 1) ||
           (col1 == col2 && (row1 - row2).abs() == 1);
  }

  void _checkWin() {
    bool won = true;
    for (int i = 0; i < _numbers.length - 1; i++) {
      if (_numbers[i] != i + 1) {
        won = false;
        break;
      }
    }
    if (won && _numbers.last == 0) {
      _isGameOver = true;
      _timer?.cancel();
      _saveScore();
      _showWinDialog();
    }
  }

  void _saveScore() async {
    final score = GameScore(
      gameId: 'number',
      score: _moves, // In this game, lower moves is better, but I'll save it as score
      duration: _formatTime(_seconds),
      date: DateTime.now(),
    );
    await StorageService().saveScore(score);
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You solved it in $_moves moves and ${_formatTime(_seconds)}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
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
        title: const Text('Number Slide'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () => setState(() => _isPaused = !_isPaused),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard('Moves', '$_moves'),
                _infoCard('Time', _formatTime(_seconds)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _size,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _numbers.length,
                    itemBuilder: (context, index) {
                      int val = _numbers[index];
                      if (val == 0) return const SizedBox.shrink();
                      return GestureDetector(
                        onTap: () => _handleTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$val',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_isPaused)
            Container(
              color: Colors.black54,
              child: Center(
                child: Text(
                  'PAUSED',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.primary)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}
