import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/data_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await DataService().getQuizHistory();
    setState(() {
      _history = history.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedLessons = DataService().lessons.where((l) => l.isCompleted).length;
    final totalLessons = DataService().lessons.length;
    final favoriteSigns = DataService().signs.where((s) => s.isFavorite).length;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.accent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aleesha User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Lessons', '$completedLessons/$totalLessons', Icons.school),
                _buildStat('Favorites', '$favoriteSigns', Icons.favorite),
                _buildStat('Quizzes', '${_history.length}', Icons.quiz),
              ],
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: AppColors.cardBackground,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(value: true, onChanged: (v) {}),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    trailing: Switch(value: false, onChanged: (v) {}),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    trailing: const Text('English'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About App'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Quiz Attempts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
              ),
            ),
            const SizedBox(height: 16),
            if (_history.isEmpty)
              const Center(child: Text('No quiz attempts yet.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final attempt = _history[index];
                  final quiz = DataService().quizzes.firstWhere((q) => q.id == attempt['quizId']);
                  return Card(
                    color: AppColors.cardBackground,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(quiz.title),
                      subtitle: Text('Score: ${attempt['score']}/${attempt['total']}'),
                      trailing: Text(
                        (attempt['date'] as String).substring(0, 10),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
