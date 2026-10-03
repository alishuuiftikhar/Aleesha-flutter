import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/game_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<GameScore>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _scoresFuture = StorageService().getScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
      ),
      body: FutureBuilder<List<GameScore>>(
        future: _scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No games played yet!'));
          }

          final scores = snapshot.data!.reversed.toList();

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.cardBackground,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondaryBackground,
                    child: Icon(_getIcon(score.gameId), color: AppColors.primary),
                  ),
                  title: Text(_getTitle(score.gameId), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('MMM dd, yyyy - HH:mm').format(score.date)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Score: ${score.score}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                      Text(score.duration, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIcon(String id) {
    switch (id) {
      case 'number': return Icons.grid_3x3;
      case 'word': return Icons.text_fields;
      case 'memory': return Icons.psychology;
      default: return Icons.extension;
    }
  }

  String _getTitle(String id) {
    switch (id) {
      case 'number': return 'Number Slide';
      case 'word': return 'Word Scramble';
      case 'memory': return 'Memory Match';
      default: return 'Puzzle';
    }
  }
}
