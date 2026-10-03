import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../theme/app_theme.dart';
import 'puzzle_games/number_puzzle.dart';
import 'puzzle_games/word_puzzle.dart';
import 'puzzle_games/memory_puzzle.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PuzzleGame> _games = [
    PuzzleGame(
      id: 'number',
      title: 'Number Slide',
      description: 'Arrange numbers in order',
      icon: '123',
    ),
    PuzzleGame(
      id: 'word',
      title: 'Word Scramble',
      description: 'Find the hidden word',
      icon: 'ABC',
    ),
    PuzzleGame(
      id: 'memory',
      title: 'Memory Match',
      description: 'Find matching pairs',
      icon: '🧠',
    ),
  ];

  String _searchQuery = '';
  List<PuzzleGame> get _filteredGames => _games
      .where((g) => g.title.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void _onGameTap(PuzzleGame game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Difficulty - ${game.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _difficultyButton('Easy', Colors.green, game),
            _difficultyButton('Medium', Colors.orange, game),
            _difficultyButton('Hard', Colors.red, game),
          ],
        ),
      ),
    );
  }

  Widget _difficultyButton(String level, Color color, PuzzleGame game) {
    return ListTile(
      title: Text(level, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        _launchGame(game, level);
      },
    );
  }

  void _launchGame(PuzzleGame game, String difficulty) {
    Widget gameWidget;
    switch (game.id) {
      case 'number':
        gameWidget = NumberPuzzlePage(difficulty: difficulty);
        break;
      case 'word':
        gameWidget = WordPuzzlePage(difficulty: difficulty);
        break;
      case 'memory':
        gameWidget = MemoryPuzzlePage(difficulty: difficulty);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => gameWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search games...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _filteredGames.length,
              itemBuilder: (context, index) {
                final game = _filteredGames[index];
                return GestureDetector(
                  onTap: () => _onGameTap(game),
                  child: Card(
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            game.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          game.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            game.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
