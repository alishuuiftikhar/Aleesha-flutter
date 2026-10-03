import 'package:flutter/material.dart';
import '../../models/game.dart';
import '../../utils/app_colors.dart';
import 'game_play_screen.dart';

class GameDetailScreen extends StatefulWidget {
  final GameModel game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.game.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  widget.game.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.secondaryBackground,
                    child: Icon(
                      _getIconData(widget.game.icon),
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'About the Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.game.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Difficulty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDifficultySelector(),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePlayScreen(
                        game: widget.game.copyWith(difficulty: _selectedDifficulty),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: Difficulty.values.map((d) {
        final isSelected = _selectedDifficulty == d;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDifficulty = d),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.secondaryBackground,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  d.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.secondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'grid_view': return Icons.grid_view;
      case 'apps': return Icons.apps;
      case 'numbers': return Icons.numbers;
      case 'auto_awesome_motion': return Icons.auto_awesome_motion;
      case 'text_fields': return Icons.text_fields;
      default: return Icons.gamepad;
    }
  }
}
