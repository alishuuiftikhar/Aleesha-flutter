import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../utils/app_colors.dart';
import '../../models/score.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final history = provider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Brain Trainee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Level 5 Mind Master',
              style: TextStyle(color: AppColors.secondary),
            ),
            const SizedBox(height: 32),
            _buildStatsSection(provider),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              const Text('No games played yet. Start training!')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length > 10 ? 10 : history.length,
                itemBuilder: (context, index) {
                  final score = history[index];
                  final game = provider.getGameById(score.gameId);
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getIconData(game?.icon ?? ''), color: AppColors.primary),
                    ),
                    title: Text(game?.title ?? 'Unknown Game'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(score.date)),
                    trailing: Text(
                      '${score.score}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(GameProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Streak', '${provider.streak}', Icons.local_fire_department),
        _buildStatItem('Best', _getBestScore(provider.history), Icons.emoji_events),
        _buildStatItem('Total', '${provider.history.length}', Icons.play_circle),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      ],
    );
  }

  String _getBestScore(List<ScoreModel> history) {
    if (history.isEmpty) return '0';
    return history.map((s) => s.score).reduce((a, b) => a > b ? a : b).toString();
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
