import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'lesson_list_screen.dart';
import 'traffic_signs_screen.dart';
import 'quiz_list_screen.dart';
import 'profile_screen.dart';
import 'checklist_screen.dart';
import 'quiz_play_screen.dart';
import '../services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardView(),
    const LessonListScreen(),
    const TrafficSignsScreen(),
    const QuizListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.secondaryBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.traffic), label: 'Signs'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Driving Academy', style: TextStyle(color: Colors.white)),
            background: Container(
              color: AppColors.primary,
              child: const Icon(Icons.directions_car, size: 80, color: AppColors.accent),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildListDelegate([
              _buildCategoryCard(context, 'Lessons', Icons.book, AppColors.secondary, const LessonListScreen()),
              _buildCategoryCard(context, 'Traffic Signs', Icons.warning, AppColors.accent, const TrafficSignsScreen()),
              _buildCategoryCard(context, 'Practice Quiz', Icons.timer, AppColors.success, const QuizListScreen()),
              _buildCategoryCard(
                context, 
                'Mock Exam', 
                Icons.assignment, 
                AppColors.error, 
                QuizPlayScreen(quiz: DataService().generateMockTest())
              ),
              _buildCategoryCard(context, 'Checklist', Icons.fact_check, Colors.blueGrey, const ChecklistScreen()),
              _buildCategoryCard(context, 'Road Rules', Icons.gavel, AppColors.secondary, const LessonListScreen()),
            ]),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.cardBackground,
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.secondary, child: Icon(Icons.check, color: Colors.white)),
                title: Text('Lesson ${index + 1} Completed'),
                subtitle: const Text('Great job! Keep learning.'),
                trailing: const Text('2h ago'),
              ),
            ),
            childCount: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}
