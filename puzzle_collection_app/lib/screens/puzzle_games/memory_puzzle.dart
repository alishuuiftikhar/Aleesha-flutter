import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/game_model.dart';
import '../../services/storage_service.dart';

class MemoryPuzzlePage extends StatefulWidget {
  final String difficulty;
  const MemoryPuzzlePage({super.key, required this.difficulty});

  @override
  State<MemoryPuzzlePage> createState() => _MemoryPuzzlePageState();
}

class _MemoryPuzzlePageState extends State<MemoryPuzzlePage> {
  final List<String> _allIcons = ['🍎', '🍌', '🍇', '🍉', '🍒', '🍓', '🍍', '🥝', '🥑', '🍔', '🍕', '🌮'];
  late List<String> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  int? _firstIndex;
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isGameOver = false;
  late int _gridCount;

  @override
  void initState() {
    super.initState();
    _gridCount = widget.difficulty == 'Easy' ? 4 : (widget.difficulty == 'Medium' ? 6 : 8);
    _startNewGame();
  }

  void _startNewGame() {
    List<String> gameIcons = _allIcons.take(_gridCount).toList();
    _cards = [...gameIcons, ...gameIcons]..shuffle();
    _flipped = List.filled(_cards.length, false);
    _matched = List.filled(_cards.length, false);
    _firstIndex = null;
    _moves = 0;
    _seconds = 0;
    _isGameOver = false;
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameOver) {
        setState(() => _seconds++);
      }
    });
  }

  void _onCardTap(int index) {
    if (_flipped[index] || _matched[index] || _isGameOver) return;

    setState(() {
      _flipped[index] = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      _moves++;
      if (_cards[_firstIndex!] == _cards[index]) {
        setState(() {
          _matched[_firstIndex!] = true;
          _matched[index] = true;
          _firstIndex = null;
          _checkWin();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _flipped[_firstIndex!] = false;
              _flipped[index] = false;
              _firstIndex = null;
            });
          }
        });
      }
    }
  }

  void _checkWin() {
    if (_matched.every((m) => m)) {
      _isGameOver = true;
      _timer?.cancel();
      _saveScore();
      _showWinDialog();
    }
  }

  void _saveScore() async {
    final score = GameScore(
      gameId: 'memory',
      score: _moves,
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
        title: const Text('Great Memory!'),
        content: Text('You found all pairs in $_moves moves and ${_formatTime(_seconds)}!'),
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
        title: const Text('Memory Match'),
        actions: [
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.difficulty == 'Easy' ? 3 : 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _flipped[index] || _matched[index]
                          ? Colors.white
                          : AppColors.primary,
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
                      _flipped[index] || _matched[index] ? _cards[index] : '?',
                      style: TextStyle(
                        fontSize: 32,
                        color: _flipped[index] || _matched[index]
                            ? Colors.black
                            : Colors.white,
                      ),
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
