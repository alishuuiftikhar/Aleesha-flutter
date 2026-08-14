import 'package:flutter/material.dart';
import '../services/app_state.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final cookedCount = appState.cookedHistoryIds.length;
    final favCount = appState.favoriteRecipeIds.length;

    final List<Map<String, dynamic>> achievements = [
      {
        'title': 'First Meal', 
        'desc': 'Cooked your first recipe!', 
        'icon': Icons.restaurant, 
        'unlocked': cookedCount >= 1, 
        'color': Colors.orange
      },
      {
        'title': 'Recipe Collector', 
        'desc': 'Saved 5 favorite recipes.', 
        'icon': Icons.favorite, 
        'unlocked': favCount >= 5, 
        'color': Colors.red
      },
      {
        'title': 'Kitchen Master', 
        'desc': 'Completed 5 cooking sessions.', 
        'icon': Icons.star, 
        'unlocked': cookedCount >= 5, 
        'color': Colors.blue
      },
      {
        'title': 'Healthy Hero', 
        'desc': 'Cooked 10 healthy category meals.', 
        'icon': Icons.health_and_safety, 
        'unlocked': cookedCount >= 10, 
        'color': Colors.green
      },
      {
        'title': 'App Guru', 
        'desc': 'Explored all app features.', 
        'icon': Icons.auto_awesome, 
        'unlocked': true, 
        'color': Colors.purple
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Achievements')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('Cooked', '$cookedCount'),
                _statItem('Favorites', '$favCount'),
                _statItem('Badges', '${achievements.where((a) => a['unlocked']).length}'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: achievements.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (ctx, index) {
                final ach = achievements[index];
                final bool unlocked = ach['unlocked'];
                return Container(
                  decoration: BoxDecoration(
                    color: unlocked ? Colors.white : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: unlocked ? ach['color'] : Colors.grey.shade300, width: 2),
                    boxShadow: unlocked ? [BoxShadow(color: ach['color'].withOpacity(0.1), blurRadius: 10)] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        ach['icon'],
                        size: 50,
                        color: unlocked ? ach['color'] : Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ach['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          ach['desc'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: unlocked ? Colors.black54 : Colors.grey),
                        ),
                      ),
                      if (!unlocked)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.lock, size: 16, color: Colors.grey),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
