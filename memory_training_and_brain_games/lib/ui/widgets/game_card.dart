import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game.dart';
import '../../providers/game_provider.dart';
import '../../utils/app_colors.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'grid_view': return Icons.grid_view;
      case 'apps': return Icons.apps;
      case 'numbers': return Icons.numbers;
      case 'auto_awesome_motion': return Icons.auto_awesome_motion;
      case 'text_fields': return Icons.text_fields;
      case 'explore': return Icons.explore;
      case 'visibility': return Icons.visibility;
      case 'calculate': return Icons.calculate;
      case 'palette': return Icons.palette;
      case 'lightbulb': return Icons.lightbulb;
      default: return Icons.gamepad;
    }
  }

  Color _getGameColor(GameType type) {
    switch (type) {
      case GameType.memoryCard: return const Color(0xFF64B5F6);
      case GameType.patternMemory: return const Color(0xFF81C784);
      case GameType.numberMemory: return const Color(0xFFFFB74D);
      case GameType.sequence: return const Color(0xFFBA68C8);
      case GameType.wordMemory: return const Color(0xFF4DB6AC);
      case GameType.spatialNavigation: return const Color(0xFFE57373);
      case GameType.speedSearch: return const Color(0xFF4DD0E1);
      case GameType.mathLogic: return const Color(0xFFAED581);
      case GameType.colorMatch: return const Color(0xFFFF8A65);
      case GameType.logicPuzzle: return const Color(0xFF9575CD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  game.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: _getGameColor(game.type).withOpacity(0.2),
                    child: Center(
                      child: Icon(
                        _getIconData(game.icon),
                        size: 48,
                        color: _getGameColor(game.type),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          game.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<GameProvider>(context, listen: false)
                              .toggleFavorite(game.id);
                        },
                        child: Icon(
                          game.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: game.isFavorite ? AppColors.error : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.difficulty.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getDifficultyColor(game.difficulty),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy: return AppColors.success;
      case Difficulty.medium: return AppColors.accent;
      case Difficulty.hard: return AppColors.error;
    }
  }
}
